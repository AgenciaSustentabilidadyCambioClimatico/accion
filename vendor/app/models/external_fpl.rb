class ExternalFpl < ActiveRecord::Base
  	self.abstract_class = true
	establish_connection :external_fpl_db

	def self.query(query)
		self.connection.exec_query(query).to_hash
	end

	def self.actualizar_proyectos
		p "===========COMIENZA CARGA DE PROYECTOS============"

		require 'date'
		require 'json'

		omitidos = []

		data = {codigo: nil, nombre: nil, contribuyente_id: nil, estado: nil, fecha_informe: nil, tipo_instrumento_id: nil, oculto: false}

		sql = 	"SELECT 
				ex.id_expediente as id_expediente, 
				ep.exppro_numero_ingreso as codigo, 
				ex.exp_nombre as nombre, 
				i.nombre_institucion as nombre_postulante, 
				i.inst_rut as rut,
				i.inst_dv as dv, 
				es.nombre_estado as estado, 
				ex.fecha_ingreso as fecha_informe,
				ep.exppro_sub_tipo as sub_tipo 
				FROM expediente ex 
				INNER JOIN estados es ON ex.id_estado=es.id_estado 
				INNER JOIN exp_proyecto ep ON ex.id_expediente=ep.id_expediente 
				INNER JOIN institucion_expediente ie ON ex.id_expediente=ie.id_expediente 
				INNER JOIN institucion i ON ie.id_institucion=i.id_institucion 
				WHERE (es.id_estado = '140' OR es.id_estado = '112')" 
		proyectos = Proyecto.all
		if proyectos.length > 0
			sql += " AND ep.exppro_numero_ingreso !~ '#{proyectos.map{|p| p.codigo}.join("|")}'"
		end

		result = self.query sql

		result.each do |ext_proyecto|

			data[:codigo] = ext_proyecto["codigo"]
			data[:nombre] = ext_proyecto["nombre"]
			data[:estado] = ext_proyecto["estado"]

			linea = data[:codigo].split('-')[0]

			if linea == "L1"
				subtipo = ext_proyecto["sub_tipo"]
				data[:tipo_instrumento_id] = "1#{subtipo}".to_i
			elsif linea == "L2"
				data[:tipo_instrumento_id] = 14
			elsif linea == "L3"
				data[:tipo_instrumento_id] = 16
			elsif linea == "L4"
				data[:tipo_instrumento_id] = 17
			else
				data[:tipo_instrumento_id] = 10
			end

			#data[:tipo_instrumento_id] =  ? TipoInstrumento::FPL_LINEA_1_1 : TipoInstrumento::FONDO_DE_PRODUCCION_LIMPIA

			contribuyente = Contribuyente.find_by(rut: ext_proyecto["rut"])
			#contribuyente = Contribuyente.find(1)
			if !contribuyente.nil?
				data[:contribuyente_id] = contribuyente.id
				data[:fecha_informe] = DateTime.strptime(ext_proyecto["fecha_informe"].to_s,'%s')

				proyecto = Proyecto.new(data)
				if proyecto.save
					self.actualizar_actividades_items ext_proyecto["id_expediente"], proyecto
				else
					puts "Omitido. Errores: #{proyecto.errors.messages}"
					omitidos << ext_proyecto
				end
			else
				puts "No se encontró contribuyente con RUT #{ext_proyecto["rut"]}"
				omitidos << ext_proyecto
			end
		end


		p "Proyectos encontrados: #{result.length}"
		p "Proyectos omitidos: #{omitidos.length}"


		p "===========FINALIZA CARGA DE PROYECTOS============"
	end

	def self.actualizar_actividades_items(id_expediente, proyecto)

		actividades_items = self.informacion_serializada(id_expediente, 'actividades')


		unless actividades_items.nil?

			actividades_items.each_with_index do |actividad, index|
				#ultimo_mes = (actividad.to_a.index {|key,| key == 'fila'}.to_i-1)
				#tiempo = 0
				#(6..ultimo_mes).each_with_index do |real, mes|
				#	tiempo += actividad["mes_#{mes+1}"].to_i
				#end

				if actividad.key?("mes_1")
					ultimo_mes = actividad.map{|k| k.last == "1" && k.first =~ /mes_[0-9]+/ ? k.first.to_s.split("_")[1].to_i : nil}.compact.sort.last

					if !ultimo_mes.nil?

						act = proyecto.proyecto_actividad.new({
							nombre: actividad["nombre"],
							duracion: ultimo_mes,
							create_external: true
						})

						if act.save

							if actividad["rrhh_propio"].length > 0
								rp = actividad["rrhh_propio"].first
								rrhh_propio = self.informacion_serializada(id_expediente, 'equipo_trabajo_ag')
								unless rrhh_propio.nil?
									rrhh_propio.each_with_index do |persona, index|
										hh = rp["ind_#{index}"]
										unless hh.blank?
											item = act.actividad_item.create({
												nombre: persona["nombre"],
												glosa_id: Glosa::RRHH_PROPIO,
												tipo_aporte_id: TipoAporte::APORTE_PROPIO_VALORADO,
												monto: hh.to_i * persona["valor_hh"].to_i
											})

											unless item.valid?
												puts item.errors.messages
												p "expediente: #{id_expediente}"
												p "actividad: #{actividad['nombre']}"
												p "item: #{persona['nombre']}"
												p "******************************************"
											end
										end
									end
								end
							end
							if actividad["rrhh_externo"].length > 0
								re = actividad["rrhh_externo"].first
								rrhh_externo = self.informacion_serializada(id_expediente, 'equipo_consultora')
								unless rrhh_externo.nil?
									rrhh_externo.each_with_index do |persona,index|
										hh = re["ind_#{index}"]
										unless hh.blank?
											item = act.actividad_item.create({
												nombre: persona["nombre"],
												glosa_id: Glosa::RRHH_EXTERNO,
												tipo_aporte_id: TipoAporte.id_por_nombre(re["tipo_aporte"]),
												monto: hh.to_i * persona["valor_hh"].to_i
											})

											unless item.valid?
												puts item.errors.messages
												p "expediente: #{id_expediente}"
												p "actividad: #{actividad['nombre']}"
												p "item: #{persona['nombre']}"
												p "******************************************"
											end
										end
									end
								end
							end
							if actividad.key?("operacion")
								actividad["operacion"].each do |item|
									if item.key?("item")
										item = act.actividad_item.create({
											nombre: item["item"],
											glosa_id: Glosa::GASTOS_OPERACIONALES,
											tipo_aporte_id: TipoAporte.id_por_nombre(item["tipo_aporte"]),
											monto: item["valor_unitario"].to_i*item["cantidad"].to_i
										})

										unless item.valid?
											puts item.errors.messages
											p "expediente: #{id_expediente}"
											p "actividad: #{actividad['nombre']}"
											p "item: #{item['item']}"
											p "******************************************"
										end
									end
								end
							end
							if actividad.key?("administracion")
								actividad["administracion"].each do |item|
									if item.key?("item")
										item = act.actividad_item.create({
											nombre: item["item"],
											glosa_id: Glosa::GASTOS_ADMINISTRATIVOS,
											tipo_aporte_id: TipoAporte.id_por_nombre(item["tipo_aporte"]),
											monto: item["valor_unitario"].to_i*item["cantidad"].to_i
										})

										unless item.valid?
											puts item.errors.messages
											p "expediente: #{id_expediente}"
											p "actividad: #{actividad['nombre']}"
											p "item: #{item['item']}"
											p "******************************************"
										end
									end
								end
							end

						else
							puts act.errors.messages
							p "expediente: #{id_expediente}"
							p "actividad: #{actividad['nombre']}"
							p "******************************************"
						end
					else
						p "expediente: #{id_expediente}"
						p "actividad: #{actividad['nombre']}"
						p "******************************************"
					end
				end
			end
		end
	end

	def self.informacion_serializada(id_expediente, tipo)
		data = nil
		sql = "SELECT td.tedo_contenido 
						FROM texto_documento td 
						JOIN partes_documento pd ON td.id_parte = pd.id_parte 
						JOIN documento d ON td.id_documento = d.id_documento 
						WHERE d.id_expediente = #{id_expediente} 
						AND d.id_documentotipo IN (7000,9500,8000,9000,6000,5000) 
						AND pd.pado_codigo LIKE '#{tipo}' 
						AND d.doc_id_documento2 IS NOT NULL 
						ORDER BY d.fecha_publicado DESC LIMIT 1"
		result = self.query sql

		if result.length > 0
			serialized = nil
			result_json = nil
			begin
				serialized = result.first["tedo_contenido"]
				serialized = serialized.gsub('"',%q(\\\"))

				# comando para llamar a archivo php que lo convierte a json
				cmd = "php files/project_details.php \"#{serialized}\""
				# %x hace ejecucion de comandos y recibe respuesta
				result_json= %x[#{cmd}]
				data = JSON.parse(result_json)

			rescue => e

  			p "**************************************************"
				p e.message
  			p "----------------------------------------------------"
  			p serialized
  			p result_json
  			p "**************************************************"
			end
		end
		data
	end

end
