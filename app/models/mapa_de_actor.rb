class MapaDeActor < ApplicationRecord
	belongs_to :flujo
	belongs_to :persona
	belongs_to :rol
	belongs_to :persona_cargo, optional: true

	# validaciones creados para la vista asignar usuarios cargo de entregables certificacion
	# validates :institucion_entregables, presence: true, if: -> { [:entregables_carga_datos,:entregables].include?(self.tipo) &&  }
	validates :usuario_entregables, presence: true, if: -> { [:entregables_carga_datos,:entregables].include?(self.tipo) }
	# validates :observacion_entregables, presence: true, if: -> { [:entregables_carga_datos,:entregables].include?(self.tipo) }
	# validates :institucion_carga_datos, presence: true, if: -> { [:entregables_carga_datos,:carga_datos].include?(self.tipo) }
	validates :usuario_carga_datos, presence: true, if: -> { [:entregables_carga_datos,:carga_datos].include?(self.tipo) }
	# validates :observacion_carga_datos, presence: true, if: -> { [:entregables_carga_datos,:carga_datos].include?(self.tipo) }

	# campos creados para la vista asignar usuarios cargo de entregables certificacion
	attr_accessor :tipo
	attr_accessor :institucion_entregables, :usuario_entregables, :observacion_entregables
	attr_accessor :institucion_carga_datos, :usuario_carga_datos, :observacion_carga_datos

	def self.columnas_excel
		["ROL EN ACUERDO", "RUT PERSONA", "NOMBRE COMPLETO PERSONA", "CARGO EN INSTITUCION", 
            "RUT INSTITUCION", "RAZON SOCIAL", "CODIGO CIIUv2", "TIPO DE INSTITUCION", "DIRECCION INSTITUCION", 
            "COMUNA INSTITUCION", "EMAIL INSTITUCIONAL", "TELEFONO INSTITUCIONAL"]
		{
			rol_en_acuerdo: 'roles', #0
			rut_persona: nil, #1
			nombre_completo_persona: nil, #2
			cargo_en_institucion: "cargos", #3
			rut_institucion: nil, #4
			razon_social: nil,
			codigo_ciiuv2: 'sectores', #5
			tipo_de_institucion: 'tipo_instituciones', #6
			direccion_institucion: nil, #7
			comuna_institucion: 'comunas', #8
			email_institucional: nil, #9
			telefono_institucional: nil, #10			
		} 
	end

	def campos_invalidos_asignar_cargo
		campo_errores = []
		# DZC 2018-11-06 14:34:29 se eliminan :institucion_entregables,y:institucion_carga_datos, :observacion_entregables y :observacion_carga_datos de la obligatoriedad
		[:usuario_entregables, :usuario_carga_datos].each do |field|
			campo_errores << field if self.send(field).blank?
		end
		campo_errores
	end

	def self.construye_data_para_apl (flujo)
		data = []
		actores = MapaDeActor.where(flujo_id: flujo.id).each do |actor|
			
			persona = actor.persona
			rut_persona = persona.user.rut
			nombre_completo_persona = persona.user.nombre_completo
			# DZC 2018-10-09 16:42:19 WARNING: Si la persona no tiene un cargo, entonces no se agregará a la construcción de la matriz de actores

			# DZC 2018-10-30 11:44:50 se modifica el método para instanciar una sola persona cargo en caso de que el dato correspondiente se haya ingresado en el registro de la tabla Mapa de Actores
			if actor.persona_cargo.blank?
				persona_cargo = PersonaCargo.where(persona_id: persona.id)
			else
				persona_cargo = [actor.persona_cargo]
			end
			persona_cargo.each do |p|
				institucion = persona.contribuyente
				acteco = institucion.actividad_economica_contribuyentes.first.actividad_economica if institucion.actividad_economica_contribuyentes.first.present?
				dato_anual = institucion.dato_anual_contribuyentes.order(periodo: :desc).first
				establecimiento = institucion.establecimiento_contribuyentes.where(casa_matriz: true).blank? ?
					institucion.establecimiento_contribuyentes.first :
					institucion.establecimiento_contribuyentes.where(casa_matriz: true).first

				rol_en_acuerdo = actor.rol.nombre
				cargo_en_institucion = p.cargo.nombre
				institucion = persona.contribuyente
				rut_institucion = institucion.rut.to_s+'-'+institucion.dv.to_s
				codigo_ciiuv2 = acteco.present? ? acteco.codigo_ciiuv2 : ""
				tipo_institucion = dato_anual.present? ? dato_anual.tipo_contribuyente.nombre : ""
				direccion = establecimiento.present? ? establecimiento.direccion : ""
				comuna = establecimiento.present? ? establecimiento.comuna.nombre : ""
				email_institucional = persona.email_institucional
				telefono_institucional = persona.telefono_institucional
				sector_productivo = acteco.present? ? acteco.descripcion : ""
				razon_social = institucion.razon_social
				data << {
					rol_en_acuerdo: rol_en_acuerdo, 
					rut_persona: rut_persona,
					nombre_completo_persona: nombre_completo_persona,  
					cargo_en_institucion: cargo_en_institucion,
					rut_institucion: rut_institucion,
					razon_social: razon_social,
					codigo_ciiuv2: codigo_ciiuv2,
					tipo_de_institucion: tipo_institucion,
					direccion_institucion: direccion,
					comuna_institucion: comuna,
					email_institucional: email_institucional,
					telefono_institucional: telefono_institucional,
					sector_productivo: sector_productivo					
				}
			end
		end
		data
	end

	def self.construye_datos_actores_para_excel (data)
		para_excel = data # extrañamente al trabajar directamente sobre 'data' se altera el contenido de @actores
		para_excel = para_excel.map {|i| i.map {|k,v| v unless (k==:sector_productivo)}.compact} #transforma un array de hashes en array de arrays, eliminando el sector productivo y la razon social
	end
	
	def self.adecua_actores_para_vista (data)
		actores = data
		actores.each do |fila|
			ae = ActividadEconomica.where(codigo_ciiuv2: fila[:codigo_ciiuv2].to_s)
			sector_productivo = ae.first.descripcion if ae.present?
			# DZC 2018-10-10 16:09:11 se prevee el caso de que el contribuyente se este creando mediante el archivo excel
			razon_social = Contribuyente.where(rut: fila[:rut_institucion]).blank? ? nil : Contribuyente.where(rut: fila[:rut_institucion]).first.razon_social
			if !fila.has_key?(:sector_productivo) then fila[:sector_productivo] = sector_productivo end
			if !fila.has_key?(:razon_social) then fila[:razon_social] = razon_social end
		end
		actores
	end

	def self.dominios
		{
			roles: Rol.all.order(nombre: :asc).map {|r| r.nombre}.compact,
			cargos: Cargo.all.order(nombre: :asc).map {|c| c.nombre}.compact,
			sectores: ActividadEconomica.order(codigo_ciiuv2: :asc).all.map {|ac| ac.codigo_ciiuv2}.compact,
			comunas: Comuna.order(nombre: :asc).all.map {|c| c.nombre}.compact,
			# comunas: Comuna.order(nombre: :asc).vigente?.all.map {|c| c.nombre}.compact, #REEMPLAZAR CUANDO SE HAGA MERGE CON RAMA DE RICARDO
			tipo_instituciones: TipoContribuyente.order(nombre: :asc).all.map {|ti| ti.nombre}.compact
		}
	end

	def self.construye_dominios_para_excel
		filas=[]
		dominios = self.dominios
		roles = dominios[:roles]
		cargos = dominios[:cargos]
		sectores = dominios[:sectores]
		comunas = dominios[:comunas]
		tipo_instituciones = dominios[:tipo_instituciones]
		(0..(sectores.length-1)).each do |cont|
			filas << [
				roles[cont].nil? ? nil : roles[cont],
				cargos[cont].nil? ? nil : cargos[cont],
				sectores[cont],
				comunas[cont].nil? ? nil : comunas[cont],
				tipo_instituciones[cont].nil? ? nil : tipo_instituciones[cont]
			]
		end
		filas
	end

	# DZC 2018-10-30 17:20:16 se agregan APL-001, APL-009 y APL-013 para efecto de determinar actores que no se pueden eliminar
	def self.roles_no_actualizables (tarea_codigo)
		roles=[]
		case tarea_codigo
		when Tarea::COD_APL_001, Tarea::COD_APL_005, Tarea::COD_APL_018, Tarea::COD_APL_020, Tarea::COD_APL_021
			roles = [Rol::PROPONENTE, Rol::REVISOR_TECNICO, Rol::COGESTOR, Rol::COORDINADOR, Rol::JEFE_DE_LINEA, Rol::CARGADOR_DATOS_ACUERDO]
		when Tarea::COD_APL_009, Tarea::COD_APL_010, Tarea::COD_APL_013, Tarea::COD_APL_014 #DZC 2018-10-23 11:39:26 se corrige error relativo a las tareas desde las que se autoriza la modificación del mapa de actores
			roles = [Rol::PROPONENTE, Rol::REVISOR_TECNICO, Rol::COGESTOR, Rol::COORDINADOR, Rol::JEFE_DE_LINEA, Rol::CARGADOR_DATOS_ACUERDO, Rol::RESPONSABLE_ENTREGABLES]
		when Tarea::COD_APL_023
			roles = [Rol::PROPONENTE, Rol::REVISOR_TECNICO, Rol::COGESTOR, Rol::COORDINADOR, Rol::JEFE_DE_LINEA, Rol::CARGADOR_DATOS_ACUERDO, Rol::FIRMANTE, Rol::AUDITOR, Rol::RESPONSABLE_CUMPLIMIENTO_COMPROMISOS]
		end
		roles
	end

	def self.roles_minimos_necesarios(tarea_codigo)
		 
		roles={}
		case tarea_codigo
		when Tarea::COD_APL_018, Tarea::COD_APL_020, Tarea::COD_APL_021
			roles = {Rol.find(Rol::FIRMANTE).nombre => 2, Rol.find(Rol::NEGOCIADOR).nombre => 2}
		when Tarea::COD_APL_023
			roles = {Rol.find(Rol::COMITE_COORDINADOR).nombre => 2, Rol.find(Rol::RESPONSABLE_ENTREGABLES).nombre => 1}
		end
		roles
	end

	def self.actualiza_tablas_mapa_actores (data, flujo=nil, tarea_pendiente=nil, historico = false) #DZC SOLO LLAMAR DESDE USO DE REST POR EDITOR
		if !flujo.nil?
			manifestacion = flujo.manifestacion_de_interes
			#DZC resetea el valor del campo mapa_de_actores_data en la manifestación de interés
			unless manifestacion.blank?
				manifestacion.temporal = true
				manifestacion.update(mapa_de_actores_data: nil)
			end
			proyecto = flujo.proyecto
			progama = flujo.ppp
			personas_en_mapa = MapaDeActor.where(flujo_id: flujo.id).all.includes(:rol)
			personas_en_mapa.each do |pem|
				unless self.roles_no_actualizables(tarea_pendiente.tarea.codigo).include?(pem.rol.id.to_i)
						pem.delete
				end
			end
		end
		# personas_en_mapa.save
		data.each do |fila|
			#obtiene el flujo de ser historico he instancia personas.-
			if flujo.nil? && fila[:codigo].present? && historico
				flujo = Flujo.find_by_codigo(fila[:codigo])
				personas_en_mapa = MapaDeActor.where(flujo_id: flujo.id).all.includes(:rol)
				personas_en_mapa.each do |pem|
					pem.delete
				end
			end
			#DZC (1) Verifica la existencia del contribuyente y en caso de ausencia lo crea.
			contribuyente = Contribuyente.find_by(rut: (fila[:rut_institucion][0,fila[:rut_institucion].length-2].to_i))
			if contribuyente.blank?
				contribuyente = Contribuyente.new(
					rut: (fila[:rut_institucion][0,fila[:rut_institucion].length-2]).to_i,
					dv: (fila[:rut_institucion][fila[:rut_institucion].length-1,1]).to_s.gsub(/k/,'K'),
					razon_social: fila[:razon_social].to_s
					)
				# DZC 2018-10-03 12:12:18 se corrige error que transformaba en boolean la variable contribuyente
				contribuyente.save(validate: false) 
			end

			#DZC (2) verifica la existencia de las actividades económicas y en caso de ausencia las crea.
			actividad_economica = ActividadEconomica.find_by(codigo_ciiuv2: fila[:codigo_ciiuv2])
			aaeec = contribuyente.actividad_economica_contribuyentes.includes(:actividad_economica).where({"actividad_economicas.codigo_ciiuv2" => fila[:codigo_ciiuv2].to_s}).first # realiza un select join
			if aaeec.blank? 
				aaeec = ActividadEconomicaContribuyente.new(
					actividad_economica_id: actividad_economica.id,
					contribuyente_id: contribuyente.id
					)
				#DZC 2018-10-03 12:12:55 se corrige error que transformaba en boolean la variable aaeec
				aaeec.save(validate: false)
			end

			#DZC (3) verifica que el contribuyente y el tipo de contribuyente esten relacionados según la tabla dato anual contribuyente 
			tipo_contribuyente = TipoContribuyente.find_by(nombre: fila[:tipo_de_institucion].to_s)
			datos_anuales_contribuyente = contribuyente.dato_anual_contribuyentes.includes(:tipo_contribuyente).where({"tipo_contribuyentes.nombre" => fila[:tipo_de_institucion].to_s}).last
			if datos_anuales_contribuyente.blank?
				datos_anuales_contribuyente = DatoAnualContribuyente.new(
					contribuyente_id: contribuyente.id,
					tipo_contribuyente_id: tipo_contribuyente.id
					)
				# DZC 2018-10-03 12:13:24 se corrige error que transformaba en boolean la variable datos_anuales_contribuyente
				datos_anuales_contribuyente.save(validate: false)
			end

			#DZC (4) verifica la ubicación del contribuyente y en caso de ausencia crea y asocia el establecimiento.
			comuna = Comuna.where(nombre: fila[:comuna_institucion].to_s).includes(provincia: [region: [:pais]]).where({"paises.nombre" => "Chile"}).first #modificar para el caso de que puedan existir comunas repetidas
			
			establecimiento_contribuyente = contribuyente.establecimiento_contribuyentes.where(direccion: fila[:direccion_institucion]).includes(:comuna).where({"comunas.nombre" => fila[:comuna_institucion].to_s}).first
			
			if establecimiento_contribuyente.blank?
				establecimiento_contribuyente = EstablecimientoContribuyente.new(
					contribuyente_id: contribuyente.id,
					casa_matriz: true, # DZC 2018-10-23 15:34:05 se asocia la dirección a la casa matríz del establecimiento
					direccion: fila[:direccion_institucion],
					pais_id: comuna.provincia.region.pais.id,
					region_id: comuna.provincia.region.id,
					comuna_id: comuna.id,
					telefono: fila[:telefono_institucional],
					email: fila[:email_institucional]
					)
				# DZC 2018-10-03 12:06:56 Se corrige error que instanciaba como boolean la variable establecimiento_contribuyente
				establecimiento_contribuyente.save(validate: false)
			end

			##
			# DZC (5) se busca la existencia del usuario y persona, en caso de ausencia se crean.
			# DZC 2018-10-20 19:45:45 se consideran el rut y el email en conjunto para la búsqueda del usuario
			# DZC 2019-08-05 se corrige validación de email, pues es posible que el correo exista en una 
			# relación persona pero no en la tabla user.
			usuario = User.find_by(rut: fila[:rut_persona].to_s)
			unless usuario.present?
				##
				# DZC 2019-08-08 15:20:37
				# Se precave posibilidad de que se produzca un error en la creación del usuario por existir otro
				# con el mismo email.
				begin
					usuario = User.invite!(
						rut: fila[:rut_persona].to_s.gsub(/k/,'K'),
						nombre_completo: fila[:nombre_completo_persona].to_s,
						telefono: fila[:telefono_institucional].to_s,
						email: fila[:email_institucional].to_s
					)
					# DZC 2018-10-03 12:08:26 Se corrige error que transformaba la variable usuario a boolean
					usuario.save(validate: false)
				rescue Exception => e
					puts("Se produjo el error #{e} en la creación de un nuevo usuario por mapa de actores#{flujo.present? ? ' para el flujo '+flujo.id: ''}#{tarea_pendiente.present? ? ' tarea_pendiente '+tarea_pendiente.id : ''}") rescue nil
				end
			else
				unless historico 
					usuario.update(
						nombre_completo: fila[:nombre_completo_persona].to_s,
						telefono: fila[:telefono_institucional].to_s
						)
				end
			end

			##
			# DZC 2018-10-23 15:28:19 se determina la persona relacionada con ese usuario y contribuyente
			# (solo puede haber una persona por institución para el usuario)
			persona = Persona.where(user_id: usuario.id, contribuyente_id: contribuyente.id).first

			##
			# DZC 2019-08-08 13:21:10 se modifica para actualizar el email institucional de la relación
			# persona.
			if persona.present?
					persona.update(
						telefono_institucional: fila[:telefono_institucional].to_s,
						email_institucional: fila[:email_institucional].to_s
						)
			else 
				persona = Persona.new(
					user_id: usuario.id,
					contribuyente_id: contribuyente.id,
					email_institucional: fila[:email_institucional].to_s,
					telefono_institucional: fila[:telefono_institucional].to_s
					)
				# DZC 2018-10-03 12:09:20 se corrige error que seteaba persona como boolean
				persona.save(validate: false)
			end

			# DZC 2018-10-23 15:28:43 se determinan los cargos asociados a estas personas
			cargos_usuario = PersonaCargo.where(persona_id: persona.id)

			# DZC 2018-10-23 15:29:20 se determina el cargo señalado en la planilla
			cargo_planilla = fila[:cargo_en_institucion].present? ? Cargo.find_by(nombre: fila[:cargo_en_institucion].to_s) : nil

			# DZC 2018-10-23 15:32:08 hay un cargo en la planilla, pero no se corresponde con alguno que el usuario tenga con ese contribuyente
			
			if cargo_planilla.present?
				 persona_cargo_institucion = PersonaCargo.where(persona_id: persona.id, cargo_id: cargo_planilla.id
				 	).first
				 if persona_cargo_institucion.blank?
				 	persona_cargo_institucion = PersonaCargo.new(persona_id: persona.id,
				 	 cargo_id: cargo_planilla.id
				 	 )
				 	persona_cargo_institucion.save(validate: false)
				 end

			# DZC 2018-10-30 11:15:04 se mantiene por si hay que reversar el cambio

				# if cargos_usuario.blank? || !cargos_usuario.pluck(:cargo_id).include?(cargo_planilla.id)	
				# # DZC 2018-10-23 16:04:26 se crea el cargo asociado
				# 	persona_cargo_institucion = PersonaCargo.new(
				# 		persona_id: persona.id,
				# 		cargo_id: cargo_planilla.id
				# 			)
				# 		#DZC 2018-10-03 12:09:53 se corrige error que seteaba persona_cargo_institucion como boolean
				# 	persona_cargo_institucion.save(validate: false)
				# end
			# DZC

			else #DZC 2018-10-30 11:09:27 se agrega para evitar problemas al instanciar el dato en mapa_de_actores
				persona_cargo_institucion = nil
			end
			
			persona_cargo_institucion_id = persona_cargo_institucion.blank? ? nil : persona_cargo_institucion.id

			#DZC (7) se busca la existencia del rol y reemplaza o modifica según corresponda
			rol = Rol.find_by(nombre: fila[:rol_en_acuerdo].to_s)
			actor = MapaDeActor.where(flujo_id: flujo.id, persona_id: persona.id, rol_id: rol.id)
			if actor.blank?
				# DZC 2018-10-30 11:10:37 se modifica para agregar persona_cargo_id
				actor = MapaDeActor.new(
					flujo_id: flujo.id,
					persona_id: persona.id,
					rol_id: rol.id,
					persona_cargo_id: persona_cargo_institucion_id
					).save(validate: false)
			else
				actor.update(persona_cargo_id: persona_cargo_institucion_id)
			end
		end
	end
end
