module Admin::CargasHistoricasHelper
	def columnas_excel_instrumentos
    {
      codigo: nil, #0
      nombre_instancia_instrumento: nil, #1
      motivacion: nil, #2
      sectores_economicos: nil, #3
      lugares: nil, #4
      instrumentos_relacionados: nil #5
    } 
  end

  #permite validar que los datos son correctos, y luego los guarda o devuelve un mensaje de error.-
  def validacion_data_historico_instrumento excell, campos_base = []
    data = []
    data_formateada = []
    if excell.present?
      header = columnas_excel_instrumentos.map{|v,k| v}
      #header = [1,2,3,4]#evaluar los header
      data = ExcelParser.new(excell, header).tabulated
    end
    errores = columnas_excel_instrumentos.transform_values{|v| []}
    errores.store(:base, [])
		archivo_correcto = true
		formato_codigo = Regexp.new('^([a-zA-Z]{3})[-](.{3})[-](\d{3})(\/)(\d{4})$')
		if data.size <= 0
			errores.store(:archivo_elementos, " Debe indicar al menos un instrumento historico")
		else			
			instituciones_con_archivo = []

			data.each_with_index do |fila, posicion|
				vacios = 0
				campos_base.each do |campo|
					if fila[campo].blank?
						vacios += 1
					end
				end
				
				if vacios > 0
					errores[:base] << " El archivo contiene celdas base sin completar, para la fila #{(posicion+2)}"
				elsif !formato_codigo.match?(fila[:codigo])
					errores[:base] << " El archivo contiene un formato de codigo inválido, para la fila #{(posicion+2)}"
				else
					separadores = ['-', "/"]
					separadores_corchetes = ['[', "]"]
					codigo = fila[:codigo]
					codigo = codigo.split(Regexp.union(separadores))
					if codigo[0].upcase == "APL"
						case codigo[1].upcase
						when "NCH"
							fila.store(:tipo_instrumento_id, "5")
						when "AVP"
							fila.store(:tipo_instrumento_id, "6")
						when "AVC"
							fila.store(:tipo_instrumento_id, "7")
						when "APS"
							fila.store(:tipo_instrumento_id, "8")
						when "APA"
							fila.store(:tipo_instrumento_id, "20")
						end
						manifestacion_de_interes_attributes = {}
						manifestacion_de_interes_attributes.store("nombre_acuerdo", fila[:nombre_instancia_instrumento])
						manifestacion_de_interes_attributes.store("motivacion_y_objetivos", fila[:motivacion])	
						sectores_economicos = fila[:sectores_economicos]
						if sectores_economicos.present?												
							sectores_economicos = sectores_economicos.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							sectores_economicos_validos = {}
							sectores_economicos.each do |sector_economico|
								ae  = ActividadEconomica.find_by_codigo_ciiuv2(sector_economico)
								if ae.present?
									sectores_economicos_validos.store(ae.id, ae.descripcion_ciiuv2)
								else
									errores[:sectores_economicos] << " El sector_economico #{sector_economico} es invalido, para la fila #{(posicion+2)}"
								end
							end
							manifestacion_de_interes_attributes.store("sectores_economicos", sectores_economicos_validos)
						end
						lugares = fila[:lugares]
						if lugares.present?
							lugares = lugares.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							territorios_regiones = {}
							territorios_provincias = {}
							territorios_comunas = {}

							lugares.each do |lugar|
								region = Region.find_by_nombre(lugar)
								provincia = Provincia.find_by_nombre(lugar)
								comuna = Comuna.find_by_nombre(lugar)
								if region.present?
									territorios_regiones.store(region.id, region.nombre)
								end
								if provincia.present?
									territorios_provincias.store(provincia.id, provincia.nombre)
								end
								if comuna.present?
									territorios_comunas.store(comuna.id, comuna.nombre)
								end
								if region.blank? && provincia.blank? && comuna.blank?
									errores[:lugares] << " El lugar #{lugar} es invalido, para la fila #{(posicion+2)}"
								end
							end
							manifestacion_de_interes_attributes.store(:territorios_regiones, territorios_regiones)
							manifestacion_de_interes_attributes.store(:territorios_provincias, territorios_provincias)
							manifestacion_de_interes_attributes.store(:territorios_comunas, territorios_comunas)
						end
						instrumentos_validados = {}
						instrumentos = fila[:instrumentos_relacionados]
						if instrumentos.present?
							instrumentos = instrumentos.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							instrumentos.each do |instrumento|
								flujo = Flujo.find_by_codigo(instrumento)
								if flujo.present?
									instrumentos_validados.store(flujo.id, instrumento)
								else
									errores[:instrumentos_relacionados] << " No se ha encontrado el codigo #{instrumento}, para la fila #{(posicion+2)}"
								end
							end
						end
						manifestacion_de_interes_attributes.store(:instrumentos_relacionados_historico, instrumentos_validados)
						data_formateada << {tipo_instrumento_id: fila[:tipo_instrumento_id], codigo: fila[:codigo], terminado: true, manifestacion_de_interes_attributes: manifestacion_de_interes_attributes}					
					elsif codigo[0].upcase == "PPF"
						case codigo[1].upcase
						when "AEA"
							fila.store(:tipo_instrumento_id, "18")
						when "AE3"
							fila.store(:tipo_instrumento_id, "3")
						when "3E3"
							fila.store(:tipo_instrumento_id, "2")
						else
							errores[:codigo] << " El archivo contiene un codigo con valores invalidos, para la fila #{(posicion+2)}"
						end
						ppp_attributes = {}
						ppp_attributes.store("nombre_propuesta", fila[:nombre_instancia_instrumento])
						ppp_attributes.store("motivacion_y_objetivos", fila[:motivacion])						
						sectores_economicos = fila[:sectores_economicos]
						if sectores_economicos.present?
							sectores_economicos = sectores_economicos.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							sectores_economicos_validos = {}
							sectores_economicos.each do |sector_economico|
								ae  = ActividadEconomica.find_by_codigo_ciiuv2(sector_economico)
								if ae.present?
									sectores_economicos_validos.store(ae.id, ae.descripcion_ciiuv2)
								else
									errores[:sectores_economicos] << " El sector_economico #{sector_economico} es invalido, para la fila #{(posicion+2)}"
								end
							end
							ppp_attributes.store("sectores_economicos", sectores_economicos_validos)
						end						
						lugares = fila[:lugares]
						if lugares.present?
							lugares = lugares.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							territorios_regiones = {}
							territorios_provincias = {}
							territorios_comunas = {}

							lugares.each do |lugar|
								region = Region.find_by_nombre(lugar)
								provincia = Provincia.find_by_nombre(lugar)
								comuna = Comuna.find_by_nombre(lugar)
								if region.present?
									territorios_regiones.store(region.id, region.nombre)
								end
								if provincia.present?
									territorios_provincias.store(provincia.id, provincia.nombre)
								end
								if comuna.present?
									territorios_comunas.store(comuna.id, comuna.nombre)
								end
								if region.blank? && provincia.blank? && comuna.blank?
									errores[:lugares] << " El lugar #{lugar} es invalido, para la fila #{(posicion+2)}"
								end
							end
							ppp_attributes.store(:territorios_regiones, territorios_regiones)
							ppp_attributes.store(:territorios_provincias, territorios_provincias)
							ppp_attributes.store(:territorios_comunas, territorios_comunas)
						end						
						instrumentos_validados = {}
						instrumentos = fila[:instrumentos_relacionados]
						if instrumentos.present?
							instrumentos = instrumentos.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							instrumentos.each do |instrumento|
								flujo = Flujo.find_by_codigo(instrumento)
								if flujo.present?
									instrumentos_validados.store(flujo.id, instrumento)
								else
									errores[:instrumentos_relacionados] << " No se ha encontrado el codigo #{instrumento}, para la fila #{(posicion+2)}"
								end
							end
						end
						ppp_attributes.store(:instrumentos_relacionados_historico, instrumentos_validados)
						data_formateada << {tipo_instrumento_id: fila[:tipo_instrumento_id], codigo: fila[:codigo], terminado: true, ppp_attributes: ppp_attributes}
					elsif codigo[0].upcase == "FPL"
						case codigo[1].upcase
						when "1.1"
							fila.store(:tipo_instrumento_id, "11")
						when "1.2"
							fila.store(:tipo_instrumento_id, "12")
						when "1.3"
							fila.store(:tipo_instrumento_id, "13")
						when "2.1"
							fila.store(:tipo_instrumento_id, "14")
						when "2.2"
							fila.store(:tipo_instrumento_id, "15")
						when "3.0"
							fila.store(:tipo_instrumento_id, "16")
						when "4.0"
							fila.store(:tipo_instrumento_id, "17")
						when "511"
							fila.store(:tipo_instrumento_id, "22")
						when "512"
							fila.store(:tipo_instrumento_id, "21")
						when "513"
							fila.store(:tipo_instrumento_id, "23")
						when "5.2"
							fila.store(:tipo_instrumento_id, "24")
						else
							errores[:codigo] << " El archivo contiene un codigo con valores invalidos, para la fila #{(posicion+2)}"
						end
						proyecto_attributes = {}
						proyecto_attributes.store("nombre", fila[:nombre_instancia_instrumento])
						proyecto_attributes.store("motivacion_y_objetivos", fila[:motivacion])						
						sectores_economicos = fila[:sectores_economicos]
						if sectores_economicos.present?
							sectores_economicos = sectores_economicos.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							sectores_economicos_validos = {}
							sectores_economicos.each do |sector_economico|
								ae  = ActividadEconomica.find_by_codigo_ciiuv2(sector_economico)
								if ae.present?
									sectores_economicos_validos.store(ae.id, ae.descripcion_ciiuv2)
								else
									errores[:sectores_economicos] << " El sector_economico #{sector_economico} es invalido, para la fila #{(posicion+2)}"
								end
							end
							proyecto_attributes.store("sectores_economicos", sectores_economicos_validos)
						end
						lugares = fila[:lugares]
						if lugares.present?
							lugares = lugares.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							territorios_regiones = {}
							territorios_provincias = {}
							territorios_comunas = {}

							lugares.each do |lugar|
								region = Region.find_by_nombre(lugar)
								provincia = Provincia.find_by_nombre(lugar)
								comuna = Comuna.find_by_nombre(lugar)
								if region.present?
									territorios_regiones.store(region.id, region.nombre)
								end
								if provincia.present?
									territorios_provincias.store(provincia.id, provincia.nombre)
								end
								if comuna.present?
									territorios_comunas.store(comuna.id, comuna.nombre)
								end
								if region.blank? && provincia.blank? && comuna.blank?
									errores[:lugares] << " El lugar #{lugar} es invalido, para la fila #{(posicion+2)}"
								end
							end
							proyecto_attributes.store(:territorios_regiones, territorios_regiones)
							proyecto_attributes.store(:territorios_provincias, territorios_provincias)
							proyecto_attributes.store(:territorios_comunas, territorios_comunas)
						end
						instrumentos_validados = {}
						instrumentos = fila[:instrumentos_relacionados]
						if instrumentos.present?
							instrumentos = instrumentos.split(Regexp.union(separadores_corchetes)).reject(&:blank?)
							instrumentos.each do |instrumento|
								flujo = Flujo.find_by_codigo(instrumento)
								if flujo.present?
									instrumentos_validados.store(flujo.id, instrumento)
								else
									errores[:instrumentos_relacionados] << " No se ha encontrado el codigo #{instrumento}, para la fila #{(posicion+2)}"
								end
							end
						end
						proyecto_attributes.store(:instrumentos_relacionados_historico, instrumentos_validados)
						data_formateada << {tipo_instrumento_id: fila[:tipo_instrumento_id], codigo: fila[:codigo], terminado: true, proyecto_attributes: proyecto_attributes}
					else
						errores[:codigo] << " El archivo contiene un codigo con valores invalidos, para la fila #{(posicion+2)}"
					end
				end
			end			

			primera = true
			@resultado = nil
			errores.each do |k,v|
				if v.size > 0
					if primera
						@resultado = "Han surgido los siguientes conflictos en la carga de instrumentos: #{v.join(',')}"
						primera = false
					else
						@resultado += ", #{v.join(',')}"						
					end
					archivo_correcto = false
				end								
			end

			if archivo_correcto				
				data_formateada.each do |instrumento|
					
					flujo = Flujo.find_or_create_by(codigo: instrumento[:codigo])
					if flujo.persisted?
						if flujo.apl?
							mdi = flujo.manifestacion_de_interes
							instrumento[:manifestacion_de_interes_attributes].store(:id, mdi.id)
						elsif flujo.ppf?
							ppp = flujo.ppp
							instrumento[:ppp_attributes].store(:id, ppp.id)
						elsif flujo.fpl?
							proyecto = flujo.proyecto
							instrumento[:proyecto_attributes].store(:id, proyecto.id)
						end						
					end
					flujo.assign_attributes(instrumento)
					flujo.save(validate: false)
				end
			end
		end
		
		@resultado
	end

	def columnas_excel_apl
    {
      codigo: nil, #0
      fecha_manifestacion_de_interes: nil, #1
      documentos_manifestacion_de_interes: nil, #2
      nombre_proyecto_avp: nil, #3
      monto_proyecto_avp: nil, #4
      diagnostico_socioambiental: nil, #5
      fecha_diagnostico_socioambiental: nil, #6
      diseño_plan_de_participacion: nil, #7
      fecha_diseño_plan_de_participacion: nil, #8
      registro_y_sistematizacion_implementacion_plan_de_participacion: nil, #9
      fecha_registro_y_sistematizacion_implementacion_plan_de_participacion: nil, #10
      diagnostico_compartido: nil, #11
      fecha_diagnostico_compartido: nil, #12
      mapa_colaborativo: nil, #13
      fecha_entrega_mapa_colaborativo: nil, #14
      planes_locales: nil, #15
      fecha_entrega_planes_locales: nil, #16
      diagnostico_general: nil, #17
      fecha_entrega_diagnostico_general: nil, #18
      fecha_firma_apl: nil, #19
      texto_apl: nil, #20
      fecha_de_auditoria_intermedia_1: nil, #21
      resultado_ponderado_auditoria_intermedia_1: nil, #22
      documentos_respaldos_auditoria_intermedia_1: nil, #23
      fecha_de_auditoria_intermedia_2: nil, #24
      resultado_ponderado_auditoria_intermedia_2: nil, #25
      documentos_respaldos_auditoria_intermedia_2: nil, #26
      fecha_de_auditoria_intermedia_3: nil, #27
      resultado_ponderado_auditoria_intermedia_3: nil, #28
      documentos_respaldos_auditoria_intermedia_3: nil, #29
      fecha_de_auditoria_final_1: nil, #30
      resultado_ponderado_auditoria_final_1: nil, #31
      documentos_respaldos_auditoria_final_1: nil, #32
      fecha_de_auditoria_final_2: nil, #33
      resultado_ponderado_auditoria_final_2: nil, #34
      documentos_respaldos_auditoria_final_2: nil, #35
      fecha_de_auditoria_final_3: nil, #36
      resultado_ponderado_auditoria_final_3: nil, #37
      documentos_respaldos_auditoria_final_3: nil, #38
      fecha_ceremonia_certificacion: nil, #39
      fecha_informe_impacto: nil, #40
      informe_de_impacto: nil, #41
    } 
  end

  def carga_data_historico_apl excell, archivos
    data = []
    data_formateada = []
    campos_base = [:codigo]
    if excell.present?
      header = columnas_excel_apl.map{|v,k| v}
      data = ExcelParser.new(excell, header).tabulated
    end
    @errores = columnas_excel_apl.transform_values{|v| []}
    @errores.store(:base, [])
    @errores.store(:blanco, [])
		archivo_correcto = true
		if data.size <= 0 || archivos.blank?
			@errores.store(:archivo_elementos, "Debe indicar al menos un APL historico o no posee archivos adjuntos cargados")
		else			
			data.each_with_index do |fila, posicion|
				vacios = 0
				campos_base.each do |campo|
					if fila[campo].blank?
						vacios += 1
					end
				end
				#buscar la manifestacion correspondiente
				flujo = Flujo.find_by_codigo(fila[:codigo])
				# manifestacion = flujo.present? ? flujo.manifestacion_de_interes : nil

				if vacios > 0
					@errores[:blanco] << (posicion+2)
				elsif flujo.blank?
					@errores[:codigo] << (posicion+2)
				else
					separadores = ['-', "/"]
					separadores_corchetes = ['[', "]"]
					codigo = fila[:codigo]
					codigo = codigo.split(Regexp.union(separadores))
					if codigo[0].upcase == "APL"
						manifestacion = flujo.manifestacion_de_interes
						documentos_diagnosticos = []
						doc_dia= [
							[:diagnostico_socioambiental, :fecha_diagnostico_socioambiental, 2], #DZC 2018-11-21 15:31:05 corresponde al recordo con el nombre 'Análisis socio ambiental' en la tabla documento_diagnosticos
							[:diseño_plan_de_participacion,:fecha_diseño_plan_de_participacion, 4], #DZC 2018-11-21 15:31:11 corresponde al recordo con el nombre 'Diseño Plan Participación' en la tabla documento_diagnosticos
							[:registro_y_sistematizacion_implementacion_plan_de_participacion, :fecha_registro_y_sistematizacion_implementacion_plan_de_participacion, 8], #DZC 2018-11-21 15:31:13 corresponde al recordo con el nombre 'Registro y sistematización implementación Plan de Participación' en la tabla documento_diagnosticos
							[:diagnostico_compartido, :fecha_diagnostico_compartido, 3], #DZC 2018-11-21 15:31:25 corresponde al recordo con el nombre 'Diagnóstico compartido' en la tabla documento_diagnosticos
							[:mapa_colaborativo, :fecha_entrega_mapa_colaborativo, 7], #DZC 2018-11-21 15:31:35 corresponde al recordo con el nombre 'Mapa Colaborativo' en la tabla documento_diagnosticos
							[:planes_locales, :fecha_entrega_planes_locales, 6], #DZC 2018-11-21 15:31:44 corresponde al recordo con el nombre 'Planes Locales' en la tabla documento_diagnosticos
							[:diagnostico_general, :fecha_entrega_diagnostico_general, 5] #DZC 2018-11-21 15:31:56 corresponde al recordo con el nombre 'Diagnóstico General' en la tabla documento_diagnosticos
						]
						doc_dia.each do |dg|
							if archivos.present?
								
								archivo_validado = nil
								archivo_nombre_validado = nil
								archivos.each do |archivo|
									
									if archivo.original_filename.downcase == fila[dg[0]].downcase
										archivo_validado = archivo
										archivo_nombre_validado = archivo.original_filename.split(".").first
									end
								end
								if archivo_validado.nil?
									@errores[dg[0]] << (posicion+2)
								end
							end

							# DZC 2018-11-21 16:16:44 se corrigen errores en tipo de datos
							unless fila[dg[1]].to_s.date_valid?
								@errores[dg[1]] << (posicion+2)
								fila[dg[1]] = nil
							else
								fila[dg[1]] = fila[dg[1]].to_date
							end

							documento_diagnostico = {
								tipo_documento_diagnostico_id: dg[2],
								nombre: archivo_nombre_validado,
								archivo: archivo_validado,
								fecha_documento: fila[dg[1]]
							}
							documentos_diagnosticos << documento_diagnostico
						end						

						auditorias_historicas = []
						aud_his = [
							[:fecha_de_auditoria_intermedia_1,
								:resultado_ponderado_auditoria_intermedia_1,
								:documentos_respaldos_auditoria_intermedia_1,
								1,
								"intermedia"],
							[:fecha_de_auditoria_intermedia_2,
								:resultado_ponderado_auditoria_intermedia_2,
								:documentos_respaldos_auditoria_intermedia_2,
								2,
								"intermedia"],
							[:fecha_de_auditoria_intermedia_3,
								:resultado_ponderado_auditoria_intermedia_3,
								:documentos_respaldos_auditoria_intermedia_3,
								3,
								"intermedia"],
							[:fecha_de_auditoria_final_1,
								:resultado_ponderado_auditoria_final_1,
								:documentos_respaldos_auditoria_final_1,
								1,
								"final"],
							[:fecha_de_auditoria_final_2,
								:resultado_ponderado_auditoria_final_2,
								:documentos_respaldos_auditoria_final_2,
								2,
								"final"], 
							[:fecha_de_auditoria_final_3,
								:resultado_ponderado_auditoria_final_3,
								:documentos_respaldos_auditoria_final_3,
								3,
								"final"]
						]
						aud_his.each do |ah|
							#Validacion de que el archivo exista
							if archivos.present?
								archivo_validado = nil
								archivos.each do |archivo|
									if archivo.original_filename.downcase == fila[ah[2]].downcase
										archivo_validado = archivo
									end
								end
								if archivo_validado.nil?
									@errores[ah[2]] << (posicion+2)
								end
							end
							# DZC 2018-11-21 16:17:29 se corrigen errores en tipo de datos
							unless fila[ah[0]].to_s.date_valid?
								@errores[ah[0]] << (posicion+2)
								fila[ah[0]] = nil
							else
								fila[ah[0]] = fila[ah[0]].to_date
							end
							auditoria = {
								tipo: ah[4],
								numero: ah[3],
								fecha: fila[ah[0]],
								resultado_ponderado: fila[ah[1]],
								documento_respaldo: archivo_validado
							}
							auditorias_historicas << auditoria
						end

						#Validacion de que el archivo de informe de impacto exista
						# DZC 2018-11-21 16:20:14 se modifica acorde al método archivo_exist?
						archivo_validado = archivo_exist?(archivos, fila[:informe_de_impacto])
						archivo_nombre_validado = archivo_validado[1]
						if archivo_validado[0].nil?
							@errores[:informe_de_impacto] << (posicion+2)
						end

						# DZC 2018-11-21 17:06:11 valida fecha informe impacto
						unless fila[:fecha_informe_impacto].to_s.date_valid?
							@errores[:fecha_informe_impacto] << (posicion+2)
							fila[:fecha_informe_impacto] = nil
						else
							fila[:fecha_informe_impacto] = fila[:fecha_informe_impacto].to_date
						end

						informe_impacto = {documento: archivo_validado[0], nombre_documento: archivo_nombre_validado, fecha_informe_impacto: fila[:fecha_informe_impacto]}
						if manifestacion.informe_impacto.present?
							informe_impacto.store(:id, manifestacion.informe_impacto.id)
						end
						

						#Validacion de que el archivo de texto_apl de impacto exista
						# DZC 2018-11-21 15:55:19 se modifica acorde al método archivo_exist?
						texto_apl_validado = archivo_exist?(archivos, fila[:texto_apl])
						if texto_apl_validado[0].nil?
							@errores[:texto_apl] << (posicion+2)
						end

						# DZC 2018-11-21 17:37:56 valida fecha de firma APL
						unless fila[:fecha_firma_apl].to_s.date_valid?
							@errores[:fecha_firma_apl] << (posicion+2)
							fila[:fecha_firma_apl] = nil
						else
							fila[:fecha_firma_apl] = fila[:fecha_firma_apl].to_date
						end						

						# DZC 2018-11-21 16:31:18  validacion de fecha manifestacion, se corrigen errores en tipo de datos
						unless fila[:fecha_manifestacion_de_interes].to_s.date_valid?
							@errores[:fecha_manifestacion_de_interes] << (posicion+2)
							fila[:fecha_manifestacion_de_interes] = nil
						else
							fila[:fecha_manifestacion_de_interes] = fila[:fecha_manifestacion_de_interes].to_date
						end

    				# DZC 2018-11-21 15:54:50 se revisa y corrige el array
						data_formateada << [ manifestacion, {
							fecha_manifestacion: fila[:fecha_manifestacion_de_interes], #1
							documentos_historicos: fila[:documentos_manifestacion_de_interes], #2
							nombre_proyecto: fila[:nombre_proyecto_avp], #3
							monto_inversion: fila[:monto_proyecto_avp], #4
							documento_diagnosticos_attributes: documentos_diagnosticos, #5-18
							firma_fecha: fila[:fecha_firma_apl], #19
							texto_apl: texto_apl_validado[0], #20
							auditoria_historicos_attributes: auditorias_historicas, #21-38
							ceremonia_certificacion_fecha_hora: fila[:fecha_ceremonia_certificacion], #39
							informe_impacto_attributes: informe_impacto #40-41
						}]
      		
					else
						@errores[:codigo] << (posicion+2)
					end
				end			
			end
		end
		@resultado = []
		@errores.each do |k,v|
			if v.size > 0
				@resultado << "La carga de APL presenta los guientes errores: \n"
				case k
				when :codigo
					@resultado << "El código ingresado no existe en el sistema o no es de tipo APL. Debe agregarlo antes de poder cargar este archivo. Para las filas números: #{v.to_sentence}"
				when :archivo_elementos
					@resultado << v
				when :diagnostico_socioambiental
					@resultado << "El Diagnóstico Socioambiental no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_diagnostico_socioambiental
					@resultado << "Formato de fecha de Diagnóstico Socioambiental no valido. Para las filas números: #{v.to_sentence}"
				when :diseño_plan_de_participacion
					@resultado << "El Diseño Plan de Participación no se encontró dentro de los archivos subido. Para las filas números: #{v.to_sentence}"
				when :fecha_diseño_plan_de_participacion
					@resultado << "Formato de fecha de Diseño Plan de Participación no valido. Para las filas números: #{v.to_sentence}"
				when :registro_y_sistematizacion_implementacion_plan_de_participacion
					@resultado << "El Registro y sistematización implementación Plan de Participación no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_registro_y_sistematizacion_implementacion_plan_de_participacion
					@resultado << "Formato de fecha de Registro y sistematización implementación Plan de Participación no valido. Para las filas números: #{v.to_sentence}"
				when :diagnostico_compartido
					@resultado << "El Diagnóstico Compartido no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_diagnostico_compartido
					@resultado << "Formato de fecha de Diagnóstico Compartido no valido. Para las filas números: #{v.to_sentence}"
				when :mapa_colaborativo
					@resultado << "El Mapa Colaborativo no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_entrega_mapa_colaborativo
					@resultado << "Formato de fecha de Mapa Colaborativo no valido. Para las filas números: #{v.to_sentence}"
				when :planes_locales
					@resultado << "El Plan Local no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_entrega_planes_locales
					@resultado << "Formato de fecha de Plan Local no valido. Para las filas números: #{v.to_sentence}"
				when :diagnostico_general
					@resultado << "El Diagnóstico General no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_entrega_diagnostico_general
					@resultado << "Formato de fecha de Diagnóstico General no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_de_auditoria_intermedia_1
					@resultado << "Formato de fecha de auditoría intermedia 1 no válido. Para las filas números: #{v.to_sentence}"
				when :fecha_de_auditoria_intermedia_2
					@resultado << "Formato de fecha de auditoría intermedia 2 no válido. Para las filas números: #{v.to_sentence}"					
				when :fecha_de_auditoria_intermedia_3
					@resultado << "Formato de fecha de auditoría intermedia 3 no válido. Para las filas números: #{v.to_sentence}"
				when :fecha_de_auditoria_final_1
					@resultado << "Formato de fecha de auditoría final 1 no válido. Para las filas números: #{v.to_sentence}"
				when :fecha_de_auditoria_final_2
					@resultado << "Formato de fecha de auditoría final 2 no válido. Para las filas números: #{v.to_sentence}"					
				when :fecha_de_auditoria_final_3
					@resultado << "Formato de fecha de auditoría final 3 no válido. Para las filas números: #{v.to_sentence}"						
				when :informe_impacto
					@resultado << "El Informe Impacto no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_informe_impacto
					@resultado << "Formato de fecha de Informe impacto no valido. Para las filas números: #{v.to_sentence}"					
				when :fecha_manifestacion_de_interes
					@resultado << "Formato de fecha de Manifestación de interes no valido. Para las filas números: #{v.to_sentence}"
				when :texto_apl
					@resultado << "El Texto APL no se encontró dentro de los archivos subidos. Para las filas números: #{v.to_sentence}"
				when :fecha_firma_apl
					@resultado << "Formato de fecha de Fecha firma APL no valido. Para las filas números: #{v.to_sentence}"									
				end
				archivo_correcto = false
			end	
		end
		
		if archivo_correcto				
			data_formateada.each do |apl|					
				
				manifestacion = apl[0]
				manifestacion.documento_diagnosticos.clear
				manifestacion.auditoria_historicos.clear
				manifestacion.assign_attributes(apl[1])
				manifestacion.save(validate: false)
			end
		end	
		@resultado
	end

	def columnas_excel_ppf
		# DZC 2018-11-21 11:54:37 se corrigen errores en nombre de campos
    {
      codigo: nil, #0
      relevancia_agencia: nil, #1
      instrumento_financiamiento: nil, #2
      monto_solicitado_m: nil, #3
      fecha_elaboracion_propuesta: nil, #4
      propuesta_y_documentos_asociados: nil, #5
      carta_de_apoyo: nil, #6
      fecha_carta_de_apoyo: nil, #7
      fecha_postulacion: nil, #8
      fecha_respuesta: nil, #9
      respuesta: nil, #10
      documento_respuesta: nil, #11
      codigo_bip: nil, #12
      participacion_agencia: nil, #13
      fecha_legal_inicio_proyecto: nil, #14
      monto_transferencias_1: nil, #15
      fecha_transferencia_1: nil, #16
      centro_de_costos_transferencia_1: nil, #17
      ejecucion_transferencia_1: nil, #18
      monto_transferencias_2: nil, #19
      fecha_transferencia_2: nil, #20
      centro_de_costos_transferencia_2: nil, #21
      ejecucion_transferencia_2: nil, #22
      monto_transferencias_3: nil, #23
      fecha_transferencia_3: nil, #24
      centro_de_costos_transferencia_3: nil, #25
      ejecucion_transferencia_3: nil, #26
      monto_transferencias_4: nil, #27
      fecha_transferencia_4: nil, #28
      centro_de_costos_transferencia_4: nil, #29
      ejecucion_transferencia_4: nil, #30
      documento_con_productos_y_resultados: nil, #31
      fecha_finalizacion: nil #32
    } 
  end

  # DZC 2018-11-20 21:49:22 se corrigen errores
  def carga_data_historico_ppf excell, archivos
    data = []
    data_formateada = []
    campos_base = [:codigo]
    if excell.present?
      header = columnas_excel_ppf.map{|v,k| v}
      data = ExcelParser.new(excell, header).tabulated
    end
    @errores = columnas_excel_ppf.transform_values{|v| []}
    @errores.store(:base, [])
    @errores.store(:blanco, [])
		archivo_correcto = true

		
		if data.size <= 0 || archivos.blank?
			@errores.store(:archivo_elementos, "Debe indicar al menos un PPF histórico, o se han cargado los archivos adjuntos indicados en la planilla")
		else			
			data.each_with_index do |fila, posicion|
				vacios = 0
				campos_base.each do |campo|
					if fila[campo].blank?
						vacios += 1
					end
				end

				# DZC 2018-11-20 22:01:43 se agrega para evitar error en la busqueda de un flujo que con condigo nil
				flujo = fila[:codigo].present? ? Flujo.find_by_codigo(fila[:codigo]) : nil

				if vacios > 0
					@errores[:blanco] << (posicion+2)
				elsif flujo.blank?
					@errores[:codigo] << (posicion+2)
				else
					separadores = ['-', "/"]
					separadores_corchetes = ['[', "]"]
					codigo = fila[:codigo]
					codigo = codigo.split(Regexp.union(separadores))
					if codigo[0].upcase == "PPF"
						ppp = flujo.ppp

						#Validaciones de archivo presente
						
						documento_respuesta = archivo_exist?(archivos, fila[:documento_respuesta])
						if documento_respuesta[0].nil?
							@errores[:documento_respuesta] << (posicion+2)
						end
						documento_con_productos_y_resultados = archivo_exist?(archivos, fila[:documento_con_productos_y_resultados])
						if documento_con_productos_y_resultados[0].nil?
							@errores[:documento_con_productos_y_resultados] << (posicion+2)
						end
						propuesta_y_documentos_asociados = archivo_exist?(archivos, fila[:propuesta_y_documentos_asociados])
						if propuesta_y_documentos_asociados[0].nil?
							@errores[:propuesta_y_documentos_asociados] << (posicion+2)
						end
						cartas_de_apoyo = archivo_exist?(archivos, fila[:carta_de_apoyo])
						if cartas_de_apoyo[0].nil?
							@errores[:carta_de_apoyo] << (posicion+2)
						end

						#Validaciones de formato de fecha
						
						unless fila[:fecha_elaboracion_propuesta].to_s.date_valid?
							@errores[:fecha_elaboracion_propuesta] << (posicion+2)
						end
						unless fila[:fecha_carta_de_apoyo].to_s.date_valid?
							@errores[:fecha_carta_de_apoyo] << (posicion+2)
						end
						unless fila[:fecha_postulacion].to_s.date_valid?
							@errores[:fecha_postulacion] << (posicion+2)
						end
						unless fila[:fecha_respuesta].to_s.date_valid?
							@errores[:fecha_respuesta] << (posicion+2)
						end
						unless fila[:fecha_legal_inicio_proyecto].to_s.date_valid?
							@errores[:fecha_legal_inicio_proyecto] << (posicion+2)
						end
						unless fila[:fecha_transferencia_1].to_s.date_valid?
							@errores[:fecha_transferencia_1] << (posicion+2)
						end
						unless fila[:fecha_transferencia_2].to_s.date_valid?
							@errores[:fecha_transferencia_2] << (posicion+2)
						end
						unless fila[:fecha_transferencia_3].to_s.date_valid?
							@errores[:fecha_transferencia_3] << (posicion+2)
						end
						unless fila[:fecha_transferencia_4].to_s.date_valid?
							@errores[:fecha_transferencia_4] << (posicion+2)
						end
						unless fila[:fecha_finalizacion].to_s.date_valid?
							@errores[:fecha_finalizacion] << (posicion+2)
						end

						#validacion de tipo numerico mayor a 0
						unless fila[:monto_solicitado_m].to_s.numeric?
							@errores[:monto_solicitado_m] << (posicion+2)
						end
						unless fila[:monto_transferencias_1].to_s.numeric?
							@errores[:monto_transferencias_1] << (posicion+2)
						end
						unless fila[:ejecucion_transferencia_1].to_s.numeric?
							@errores[:ejecucion_transferencia_1] << (posicion+2)
						end
						unless fila[:monto_transferencias_2].to_s.numeric?
							@errores[:monto_transferencias_2] << (posicion+2)
						end
						unless fila[:ejecucion_transferencia_2].to_s.numeric?
							@errores[:ejecucion_transferencia_2] << (posicion+2)
						end
						unless fila[:monto_transferencias_3].to_s.numeric?
							@errores[:monto_transferencias_3] << (posicion+2)
						end
						unless fila[:ejecucion_transferencia_3].to_s.numeric?
							@errores[:ejecucion_transferencia_3] << (posicion+2)
						end
						unless fila[:monto_transferencias_4].to_s.numeric?
							@errores[:monto_transferencias_4] << (posicion+2)
						end
						unless fila[:ejecucion_transferencia_4].to_s.numeric?
							@errores[:ejecucion_transferencia_4] << (posicion+2)
						end
						#Validar enum valido
						enum_respuesta = nil
						if ProgramaProyectoPropuesta.resultado_postulaciones.keys.include?(fila[:respuesta].downcase)
								enum_respuesta = fila[:respuesta].downcase
						else
							@errores[:respuesta] << (posicion+2)
						end

						ejecucion_presupuestarias = []
						eje_pre = [[:monto_transferencias_1, :fecha_transferencia_1, :centro_de_costos_transferencia_1, :ejecucion_transferencia_1], [:monto_transferencias_2, :fecha_transferencia_2, :centro_de_costos_transferencia_2, :ejecucion_transferencia_2], [:monto_transferencias_3, :fecha_transferencia_3, :centro_de_costos_transferencia_3, :ejecucion_transferencia_3]]
						eje_pre.each do |ep|
							centro_costo = CentroDeCosto.find_by_nombre(fila[ep[2]])
							if centro_costo.present?
								
								año = nil
								if fila[:fecha_legal_inicio_proyecto].present?
									año = fila[:fecha_legal_inicio_proyecto].to_date.year rescue nil
								end
								ejecucion = {montos_transferidos: fila[ep[0]], centro_de_costo_id: centro_costo.id, montos_ejecutados: fila[ep[3]], año: año, fecha_transferencia: fila[ep[1]].to_date}
								ejecucion_presupuestarias << ejecucion
							else
								@errores[ep[2]] << (posicion+2)
							end
						end

						data_formateada << [ ppp, {
							motivos_relevantes_para_postular: fila[:relevancia_agencia], #1
							nombre_del_fondo_al_cual_se_esta_postulando: fila[:instrumento_financiamiento], #2 
							monto_aproximado_a_solicitar: fila[:monto_solicitado_m], #3
							fecha_elaboracion_propuesta: fila[:fecha_elaboracion_propuesta].to_date, #4
							archivo_propuesta_elaboracion: propuesta_y_documentos_asociados[0], #5
							carta_de_apoyo_coordinador: cartas_de_apoyo[0], #6
							fecha_carta_de_apoyo: fila[:fecha_carta_de_apoyo].to_date, #7
							fecha_postulacion: fila[:fecha_postulacion].to_date, #8
							fecha_entrega_resultados: fila[:fecha_respuesta].to_date, #9
							resultado_postulacion: enum_respuesta, #10
							documento_resultados: documento_respuesta[0], #11
							codigo_bip: fila[:codigo_bip], #12
							participacion_agencia: fila[:participacion_agencia], #13
							fecha_inicio_legal_proyecto: fila[:fecha_legal_inicio_proyecto].to_date, #14
							documento_productos_resultados: documento_con_productos_y_resultados[0], #31
							fecha_finalizacion_efectiva: fila[:fecha_finalizacion].to_date, #32
							ejecucion_presupuestarias_attributes: ejecucion_presupuestarias #15-30
						}]
      		
						

					else
						@errores[:codigo] << (posicion+2)
					end
				end			
			end
		end
		@resultado = []
		@errores.each do |k,v|
			if v.size > 0
				@resultado << "La carga de PPF presenta los guientes errores: \n"
				case k
				when :codigo
					@resultado << "El código ingresado no existe en el sistema o no es de tipo PPF. Debe agregarlo antes de poder cargar este archivo. Para las filas números: #{v.to_sentence}"
				when :archivo_elementos
					@resultado << v
				when :documento_respuesta
					@resultado << "El archivo Documento respuesta no se encontró dentro de los archivos Adjuntos. Para las filas números: #{v.to_sentence}"
				when :documento_con_productos_y_resultados
					@resultado << "El archivo Documento con productos y resultados no se encontró dentro de los archivos Adjuntos. Para las filas números: #{v.to_sentence}"
				when :propuesta_y_documentos_asociados
					@resultado << "El archivo Propuesta y documentos asociados no se encontró dentro de los archivos Adjuntos. Para las filas números: #{v.to_sentence}"
				when :carta_de_apoyo
					@resultado << "El archivo Cartas de apoyo no se encontró dentro de los archivos Adjuntos. Para las filas números: #{v.to_sentence}"
				when :fecha_elaboracion_propuesta
					@resultado << "Formato de Fecha elaboración propuesta no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_carta_de_apoyo
					@resultado << "Formato de Fecha carta de apoyo no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_postulacion
					@resultado << "Formato de Fecha postulación no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_respuesta
					@resultado << "Formato de Fecha de respuesta no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_legal_inicio_proyecto
					@resultado << "Formato de Fecha legal inicio proyecto no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_transferencia_1
					@resultado << "Formato de Fecha transferencia nº1 no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_transferencia_2
					@resultado << "Formato de Fecha transferencia nº2 no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_transferencia_3
					@resultado << "Formato de Fecha transferencia nº3 no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_transferencia_4
					@resultado << "Formato de Fecha transferencia nº4 no valido. Para las filas números: #{v.to_sentence}"
				when :fecha_finalizacion
					@resultado << "Formato de Fecha finalización  no valido. Para las filas números: #{v.to_sentence}"
				when :monto_solicitado_m
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en Monto solicitado. Para las filas números: #{v.to_sentence}"
				when :monto_transferencias_1
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en Monto transferencia nº1. Para las filas números: #{v.to_sentence}"
				when :monto_transferencias_2
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en Monto transferencia nº2. Para las filas números: #{v.to_sentence}"
				when :monto_transferencias_3
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en Monto transferencia nº3. Para las filas números: #{v.to_sentence}"
				when :monto_transferencias_4
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en Monto transferencia nº4. Para las filas números: #{v.to_sentence}"
				when :centro_de_costos_transferencia_1
					@resultado << "No existe el centro de costos transferencia 1 señalado en centro de costos transferencia nº1. Para las filas números: #{v.to_sentence}"
				when :centro_de_costos_transferencia_2
					@resultado << "No existe el centro de costos transferencia 1 señalado en centro de costos transferencia nº2. Para las filas números: #{v.to_sentence}"
				when :centro_de_costos_transferencia_3
					@resultado << "No existe el centro de costos transferencia 1 señalado en centro de costos transferencia nº3. Para las filas números: #{v.to_sentence}"
				when :centro_de_costos_transferencia_4
					@resultado << "No existe el centro de costos transferencia 1 señalado en centro de costos transferencia nº4. Para las filas números: #{v.to_sentence}"
				when :ejecucion_transferencia_1
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en ejecución transferencia nº1. Para las filas números: #{v.to_sentence}"
				when :ejecucion_transferencia_2
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en ejecución transferencia nº2. Para las filas números: #{v.to_sentence}"
				when :ejecucion_transferencia_3
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en ejecución transferencia nº3. Para las filas números: #{v.to_sentence}"
				when :ejecucion_transferencia_4
					@resultado << "No se ha ingresado un formato valido de número o es menor a 0 en ejecución transferencia nº4. Para las filas números: #{v.to_sentence}"
				when :respuesta
					@resultado << "El campo respuesta solo admite los valores aceptado o rechazado. Para las filas números: #{v.to_sentence}"
				end

				archivo_correcto = false
			end	
		end
		
		if archivo_correcto				
			data_formateada.each do |apl|		
				
				ppp = apl[0]
				ppp.ejecucion_presupuestarias.clear
				ppp.assign_attributes(apl[1])
				ppp.save(validate: false)
			end
		end	
		@resultado
	end

	# DZC 2018-11-20 22:40:20 se modifica para evitar errores
	def archivo_exist? archivos, archivo_buscado
			texto_apl_validado = nil
			respuesta = [nil, nil]
		if archivos.present?
			archivos.each do |archivo|
				# DZC 2018-11-20 22:40:20 se modifica para evitar errores
				# if archivo.original_filename.casecmp?(archivo_buscado)
				
				if archivo.original_filename.downcase == archivo_buscado.downcase
					texto_apl_validado = archivo
					# DZC 2018-11-20 22:40:20 se modifica para evitar errores
					# respuesta = [texto_apl_validado, texto_apl_validado.original_filename.split(".").first]
					respuesta = [texto_apl_validado, texto_apl_validado.original_filename.split(".").first]
				end
			end
		end
		respuesta
	end

	#Historico adhesiones
	def columnas_excel_adhesiones
		{
			codigo: nil, #0
			fecha_adhesion: nil, #1
			rut_institucion: nil, #2
			nombre_institucion: nil, #3
			sector_productivo: "sectores", #4
			tipo_institucion: "tipo_instituciones", #5
			tamaño_empresa: "rango_empresa", #6
			direccion_casa_matriz: nil, #7
			comuna_casa_matriz: "comunas", #8
			rut_encargado: nil, #9
			nombre_encargado: nil, #10
			cargo_encargado: "cargos", #11
			fono_encargado: nil, #12
			email_encargado: nil, #13
			alcance: "alcances", #14
			nombre_instalacion: nil, #15
			direccion_instalacion: nil, #16
			comuna_instalacion: "comunas", #17
			tipo_elemento: nil, #18
			nombre_elemento: nil, #19
			identificador: nil, #20
			patente: nil, #21			
			nombre_archivo: nil, #22
			fecha_certificacion_1: nil, #23
			vigencia_certificacion_1: nil, #24
			rut_auditor_certificacion_1: nil, #25
			nombre_archivo_respaldo_certificacion_1: nil, #26
			fecha_certificacion_2: nil, #27
			vigencia_certificacion_2: nil, #28
			rut_auditor_certificacion_2: nil, #29
			nombre_archivo_respaldo_certificacion_2: nil, #30
			fecha_certificacion_3: nil, #31
			vigencia_certificacion_3: nil, #32
			rut_auditor_certificacion_3: nil, #33
			nombre_archivo_respaldo_certificacion_3: nil #34
		} 
	end

	def carga_data_historico_adhesiones excell, archivos
    data = []
    data_formateada = []
    data_por_codigo = []
    datos_agrupados = {}
    campos_base = [:codigo, :fecha_adhesion, :rut_institucion, :rut_encargado, :alcance, :nombre_elemento, :nombre_archivo]
    if excell.present?
      header = columnas_excel_adhesiones.map{|v,k| v}
      data = ExcelParser.new(excell, header).tabulated
    end
    @errores = columnas_excel_adhesiones.transform_values{|v| []}
    @errores.store(:base, [])
    @errores.store(:blanco, [])
    @errores.store(:encargado, [])
    @errores.store(:ppf_ad, [])
    @errores.store(:pat_ide, [])
		archivo_correcto = true
		if data.size <= 0 || archivos.blank?
			@errores.store(:archivo_elementos, "Debe indicar al menos una adhesion historica o no posee archivos adjuntos cargados")
		else			
			data.each_with_index do |fila, posicion|
				vacios = 0
				campos_base.each do |campo|
					if fila[campo].blank?
						vacios += 1
					end
				end
				flujo = Flujo.find_by_codigo(fila[:codigo])

				if vacios > 0
					@errores[:blanco] << (posicion+2)
				elsif flujo.blank?
					@errores[:codigo] << (posicion+2)
				else
					# valida institucion (si existe y si estan sus campos)
					if !fila[:rut_institucion].to_s.rut_valid?
						@errores[:rut_institucion] << fila[:rut_institucion]
					else
						fila[:rut_institucion] = fila[:rut_institucion].to_s.gsub("k","K").gsub(".","")
						rut_institucion = fila[:rut_institucion]
						contribuyente = Contribuyente.find_by(rut: rut_institucion.split('-')[0])
						if contribuyente.nil?
							if fila[:direccion_casa_matriz].blank?
								@errores[:direccion_casa_matriz] << (posicion+2)
							elsif fila[:nombre_institucion].blank?
								@errores[:nombre_institucion] << (posicion+2)
							else
								if ActividadEconomica.where(codigo_ciiuv2: fila[:sector_productivo]).first.nil?
									@errores[:sector_productivo] << (posicion+2)
								end
								if TipoContribuyente.where(nombre: fila[:tipo_institucion]).first.nil?
									@errores[:tipo_institucion] << (posicion+2)
								end
								if RangoVentaContribuyente.find_by(venta_anual_en_uf: fila[:tamaño_empresa]).nil?
									@errores[:tamaño_empresa] << (posicion+2)
								end
								if Comuna.find_by(nombre: fila[:comuna_casa_matriz]).nil?
									@errores[:comuna_casa_matriz] << (posicion+2)
								end
							end
						end
					end					

					# validaciones encargado
					user = nil
					if !fila[:rut_encargado].to_s.rut_valid?
						errores[:rut_encargado] << fila[:rut_encargado]
					else 
						user = User.find_by(rut: fila[:rut_encargado].to_s.gsub("k", 'K').gsub(".",""))
						if user.nil?
							if fila[:nombre_encargado].blank? || fila[:fono_encargado].blank? || fila[:email_encargado].blank?
								@errores[:encargado] << (posicion+2)
							else
								if Cargo.find_by(nombre: fila[:cargo_encargado]).nil?
									@errores[:cargo_encargado] << (posicion+2)
								end

								unless fila[:email_encargado].to_s.email_valid?
									@errores[:email_encargado] << (posicion+2)
								end

								unless fila[:fono_encargado].to_s.phone_valid?
									@errores[:fono_encargado] << (posicion+2)
								end
							end
						else
							@usuario = user
						end
					end
					#validaciones de alcance e instalación
					if Alcance.find_by(nombre: fila[:alcance]).nil?
						@errores[:alcance] << (posicion+2)
					else
						if flujo.ppf?
							if fila[:alcance].to_s == "Establecimiento"
								if fila[:nombre_instalacion].blank?
									@errores[:nombre_instalacion] << (posicion+2)
								else 
									ec = nil
									unless contribuyente.nil?
										ec = Establecimiento_contribuyente.where(contribuyente_id: contribuyente.id).where(nombre_de_establecimiento: fila[:nombre_instalacion]).first
									end
									if ec.nil?
										if !fila[:direccion_instalacion].blank? 
											@errores[:direccion_instalacion] << (posicion+2)
										end
										if !fila[:comuna_instalacion].blank? || Comuna.find_by(nombre: fila[:comuna_instalacion]).nil?
											@errores[:comuna_instalacion] << (posicion+2)
										end
										if !fila[:tipo_elemento].blank? 
											@errores[:tipo_elemento] << (posicion+2)
										end
									end
								end
							else
								@errores[:ppf_ad] << (posicion+2)
							end
						else
							case fila[:alcance].to_s
							when "Organización"
								# TODO: Validar organizacion
							when "Establecimiento"
								if fila[:nombre_instalacion].blank?
									errors.add(:archivo_elementos, "Debe completar la celda Nombre instalacíon para línea #{(posicion+1)}")
								else 
									ec = nil
									unless contribuyente.nil?
										ec = Establecimiento_contribuyente.where(contribuyente_id: contribuyente.id).where(nombre_de_establecimiento: fila[:nombre_instalacion]).first
									end
									if ec.nil?
										if !fila[:direccion_instalacion].blank?
											@errores[:direccion_instalacion] << (posicion+2)
										end
										if !fila[:comuna_instalacion].blank? || Comuna.find_by(nombre: fila[:comuna_instalacion]).nil?
											@errores[:comuna_instalacion] << (posicion+2)
										end
										if !fila[:tipo_elemento].blank? 
											@errores[:tipo_elemento] << (posicion+2)
										end
									end
								end
							when "Maquinaria"
								if fila[:identificador].blank? && fila[:patente].blank?
									@errores[:pat_ide] << (posicion+2)
								else 
									mq = nil
									unless contribuyente.nil?
										mq = Maquinaria.where(contribuyente_id: contribuyente.id).where("numero_serie = ? OR patente = ?", fila[:identificador], fila[:patente]).first
									end
									if mq.nil?
										if fila[:nombre_elemento].blank?
											@errores[:nombre_elemento] << (posicion+2)
										end
									end
								end
							when "Producto"
								if fila[:identificador].blank?
									errors.add(:identificador, "Debe completar las celdas Identificador para línea #{(posicion+1)}")
								end
							end
						end
					end
					#validacion de archivo
					nombre_archivo = archivo_exist? archivos, fila[:nombre_archivo]
					if nombre_archivo[0].nil?
						@errores[:nombre_archivo] << (posicion+2)
					end

					#Validaciones de certificacion
					#Se valida archivo solo en caso de ingresar una fecha
					nombre_archivo_respaldo_certificacion_1 = nil
					if fila[:fecha_certificacion_1].present?
						unless fila[:fecha_certificacion_1].to_s.date_valid?
							@errores[:fecha_certificacion_1] << (posicion+2)
						end
						nombre_archivo_respaldo_certificacion_1 = archivo_exist? archivos, fila[:nombre_archivo_respaldo_certificacion_1]
						if nombre_archivo_respaldo_certificacion_1[0].nil?
							@errores[:nombre_archivo_respaldo_certificacion_1] << (posicion+2)
						end
					end

					if fila[:fecha_certificacion_2].present?
						unless fila[:fecha_certificacion_2].to_s.date_valid?
							@errores[:fecha_certificacion_2] << (posicion+2)
						end
						nombre_archivo_respaldo_certificacion_2 = archivo_exist? archivos, fila[:nombre_archivo_respaldo_certificacion_2]
						if nombre_archivo_respaldo_certificacion_2[0].nil?
							@errores[:nombre_archivo_respaldo_certificacion_2] << (posicion+2)
						end
					end

					if fila[:fecha_certificacion_3].present?
						unless fila[:fecha_certificacion_3].to_s.date_valid?
							@errores[:fecha_certificacion_3] << (posicion+2)
						end
						nombre_archivo_respaldo_certificacion_3 = archivo_exist? archivos, fila[:nombre_archivo_respaldo_certificacion_3]
						if nombre_archivo_respaldo_certificacion_3[0].nil?
							@errores[:nombre_archivo_respaldo_certificacion_3] << (posicion+2)
						end
					end

					if datos_agrupados.has_key?(flujo.id)
						datos_agrupados[flujo.id] << fila
					else
						datos_agrupados.store(flujo.id, [fila])
					end
				end			
			end
		end
		@resultado = []
		@errores.each do |k,v|
			if v.size > 0
				case k
				when :codigo
					@resultado << "El código ingresado no existe en el sistema. Debe agregarlo antes de poder cargar este archivo. Para las filas números: #{v.to_sentence}"
				when :archivo_elementos
					@resultado << v
				when :rut_institucion
					@resultado << "Se ha ingresado un rut inválido. Para las filas números: #{v.to_sentence}"
				when :direccion_casa_matriz
					@resultado << "Debe completar la celda Direccion casa matriz. Para las filas números: #{v.to_sentence}"
				when :nombre_institucion
					@resultado << "Debe completar la celda Nombre institucion. Para las filas números: #{v.to_sentence}"
				#ff
				when :sector_productivo
					@resultado << "Sector productivo inválido. Para las filas números: #{v.to_sentence}"
				when :tipo_institucion
					@resultado << "Tipo de institución inválido. Para las filas números: #{v.to_sentence}"
				when :tamaño_empresa
					@resultado << "Tamaño de empresa inválido. Para las filas números: #{v.to_sentence}"
				when :comuna_casa_matriz
					@resultado << "Comuna de casa matriz inválido. Para las filas números: #{v.to_sentence}"
				#Validaciones encargado
				when :rut_encargado
					@resultado << "Se ha ingresado un rut inválido. Para las filas números: #{v.to_sentence}"
				when :encargado
					@resultado << "Debe completar las celdas Nombre encargado, Fono encargado y Email encargado. Para las filas números: #{v.to_sentence}"
				when :cargo_encargado
					@resultado << "Cargo encargado inválido. Para las filas números: #{v.to_sentence}"
				when :email_encargado
					@resultado << "Email encargado inválido. Para las filas números: #{v.to_sentence}"
				when :fono_encargado
					@resultado << "Fono encargado inválido. Para las filas números: #{v.to_sentence}"
				#alcance
				when :alcance
					@resultado << "Alcance  no valido. Para las filas números: #{v.to_sentence}"
				when :ppf_ad
					@resultado << "Alcance incorrecto, solo es posible adherir establecimientos. Para las filas números: #{v.to_sentence}"
				when :nombre_instalacion
					@resultado << "Nombre de instalación inválido. Para las filas números: #{v.to_sentence}"
				when :direccion_instalacion
					@resultado << "Dirección de instalación inválido. Para las filas números: #{v.to_sentence}"
				when :comuna_instalacion
					@resultado << "Comuna instalación inválido. Para las filas números: #{v.to_sentence}"
				when :tipo_elemento
					@resultado << "Tipo de elemento inválido. Para las filas números: #{v.to_sentence}"
				#elemento a certificar
				when :pat_ide
					@resultado << "Debe completar las celdas Identificador o Patente. Para las filas números: #{v.to_sentence}"
				when :nombre_elemento
					@resultado << "Debe completar la celda Nombre elemento. Para las filas números: #{v.to_sentence}"
				when :identificador
					@resultado << "Debe completar las celdas Identificador. Para las filas números: #{v.to_sentence}"
				#certificaciòn
				when :fecha_certificacion_1
					@resultado << "Formato de fecha invalido para Fecha certificación 1. Para las filas números: #{v.to_sentence}"
				when :fecha_certificacion_2
					@resultado << "Formato de fecha invalido para Fecha certificación 2. Para las filas números: #{v.to_sentence}"
				when :fecha_certificacion_3
					@resultado << "Formato de fecha invalido para Fecha certificación 3. Para las filas números: #{v.to_sentence}"
				when :nombre_archivo_respaldo_certificacion_1
					@resultado << "El archivo respaldo certificación 1 no se encontró dentro de los archivos Adjuntos. Para las filas números: #{v.to_sentence}"
				when :nombre_archivo
					@resultado << "El archivo de respaldo no se encontró dentro de los archivos Adjuntos. Para las filas números: #{v.to_sentence}"
				end
				archivo_correcto = false
			end	
		end
		if archivo_correcto				
			datos_agrupados.each do |adhesion_excell|
				adhesion = Adhesion.find_by_flujo_id(adhesion_excell[0])
				if adhesion.present?
					#De existir en la base de datos se borra la informacion existente, para ser sobreescrita.-
					adhesion.adhesion_elementos.each do |adel|
						adel.certificacion_adhesion_historicos.delete_all
					end
					adhesion.adhesion_elementos.clear
				else
					adhesion = Adhesion.new
				end
				adhesion.tipo = false
				adhesion.archivo_elementos = excell
				adhesion.flujo_id = adhesion_excell[0]
				adhesion.archivos_adhesion_y_documentacion = archivos
				adhesion.save 
				#para asignarle solo los archivos que le corresponden
				archivos_por_codigo = []
				adhesion_excell[1].each do |elemento|
					#metodo que se reutiliza para cargar las adhesiones_elementos.-
					adhesion_elemento = adhesion.poblar_data elemento, adhesion.flujo, adhesion.archivos_adhesion_y_documentacion, adhesion
					#Para guardar las certificaciones.-
					cah = CertificacionAdhesionHistorico.new
					cah.adhesion_elemento_id = adhesion_elemento.id
					cah.fecha_certificacion_1 = elemento[:fecha_certificacion_1]
					cah.vigencia_certificacion_1 = elemento[:vigencia_certificacion_1]
					cah.rut_auditor_cert_1 = elemento[:rut_auditor_cert_1]
					cah.nombre_archivo_respaldo_certificacion_1 = elemento[:nombre_archivo_respaldo_certificacion_1]
					cah.fecha_certificacion_2 = elemento[:fecha_certificacion_2]
					cah.vigencia_certificacion_2 = elemento[:vigencia_certificacion_2]
					cah.rut_auditor_cert_2 = elemento[:rut_auditor_cert_2]
					cah.nombre_archivo_respaldo_certificacion_2 = elemento[:nombre_archivo_respaldo_certificacion_2]
					cah.fecha_certificacion_3 = elemento[:fecha_certificacion_3]
					cah.vigencia_certificacion_3 = elemento[:vigencia_certificacion_3]
					cah.rut_auditor_cert_3 = elemento[:rut_auditor_cert_3]
					cah.nombre_archivo_respaldo_certificacion_3 = elemento[:nombre_archivo_respaldo_certificacion_3]
					cah.save
					archivos_por_codigo << elemento[:nombre_archivo]
				end		
				# adhesion.archivos_adhesion_y_documentacion = archivos_por_codigo
				# adhesion.save
			end
		end	
		@resultado
	end

	#Historico Mapa de actores
	def columnas_excell_actores
		{
			codigo: nil,
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

	def carga_data_historico_actores excell
    data = []
    campos_base = [:codigo, :rol_en_acuerdo, :rut_persona, :rut_institucion]
    if excell.present?
      header = columnas_excell_actores.map{|v,k| v}
      data = ExcelParser.new(excell, header).tabulated
    end
    @errores = columnas_excell_actores.transform_values{|v| []}
    @errores.store(:base, [])
    @errores.store(:blanco, [])
		archivo_correcto = true
		if data.size <= 0
			@errores.store(:archivo_elementos, "Debe indicar al menos una mapa de actor historico")
		else			
			data.each_with_index do |fila, posicion|
				vacios = 0
				campos_base.each do |campo|
					if fila[campo].blank?
						vacios += 1
					end
				end
				flujo = Flujo.find_by_codigo(fila[:codigo])
				if vacios > 0
					@errores[:blanco] << (posicion+2)
				elsif flujo.blank?
					@errores[:codigo] << (posicion+2)
				else
					# valida que exista la persona, o solicita sus datos
					usuario = User.find_by(rut: fila[:rut_persona].to_s.gsub("k",'K').gsub(".",""))
					if usuario.blank?
						if !fila[:rut_persona].to_s.rut_valid?
							@errores[:rut_persona] << fila[:rut_persona]
						else
							[fila[:nombre_completo_persona], fila[:email_institucional], fila[:telefono_institucional]].each do |campo|
								if fila[campo].blank?
									vacios += 1
								end
							end
							if vacios > 0
								@errores[:blanco] << (posicion+2)
							end
						end
					end
				end			
			end
		end
		@resultado = []
		@errores.each do |k,v|
			if v.size > 0
				case k
				when :codigo
					@resultado << "El código ingresado no existe en el sistema. Debe agregarlo antes de poder cargar este archivo. Para las filas números: #{v.to_sentence}"
				when :blanco
					@resultado << "Campos obligatorios en blanco. Debe agregarlo antes de poder cargar este archivo. Para las filas números: #{v.to_sentence}"
				when :archivo_elementos
					@resultado << v
				when :rut_persona
					@resultado << "Se ha ingresado un rut inválido. Para las filas números: #{v.to_sentence}"
				end
				archivo_correcto = false
			end	
		end
		if archivo_correcto				
			MapaDeActor.actualiza_tablas_mapa_actores(data, nil, nil, true)
		end	
		@resultado
	end

end