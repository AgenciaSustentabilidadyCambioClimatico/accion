class ManifestacionDeInteres < ApplicationRecord

	# DZC 2019-03-01 11:36:03 tiempo para mostrar el mensaje de guardar
	MINUTOS_MENSAJE_GUARDAR = 20

	belongs_to :representante, optional: true, foreign_key: :representante_institucion_para_solicitud_id, class_name: :User
	belongs_to :proponente_institucion, optional: true, foreign_key: :proponente_institucion_id, class_name: :Contribuyente
	belongs_to :institucion_gestora, optional: true, foreign_key: :contribuyente_id, class_name: :Contribuyente
	has_many :documento_diagnosticos, foreign_key: :manifestacion_de_interes_id, dependent: :destroy
	accepts_nested_attributes_for :documento_diagnosticos, allow_destroy: true
	
	attr_accessor :current_tab, :temporal, :update_admisibilidad, :update_obs_admisibilidad, 
	:update_pertinencia, :update_respuesta_pertinencia, :update_usuario_entregables, :current_user, :recuerde_guardar_reset_timer

	belongs_to :tipo_instrumento, optional: true
	belongs_to :contribuyente, optional: true
	belongs_to :estandar_homologacion, optional: true, foreign_key: :estandar_de_certificacion_id
	#Relacion de una manifestación, a una manifestacion antigua.
	belongs_to :antiguo, optional: true, foreign_key: :diagnostico_id, class_name: :ManifestacionDeInteres
	# has_many :set_metas_acciones
	has_one :flujo, dependent: :destroy
	has_one :adhesion

	# has_many :convocatorias
	has_one :informe_impacto
	accepts_nested_attributes_for :informe_impacto
	has_one :informe_acuerdo

	has_many :auditoria_historicos, dependent: :destroy
	accepts_nested_attributes_for :auditoria_historicos, allow_destroy: true

	serialize :secciones_observadas_admisibilidad
	serialize :secciones_observadas_pertinencia_factibilidad
	serialize :sectores_economicos
	serialize :territorios_regiones
	serialize :territorios_provincias
	serialize :territorios_comunas
	serialize :coordernadas_territorios
	serialize :mapa_de_actores_data
	serialize :firmantes
	serialize :comentarios_y_observaciones_actualizacion_mapa_de_actores
	serialize :comentarios_y_observaciones_documento_diagnosticos
	serialize :comentarios_y_observaciones_set_metas_acciones
	serialize :informe
	serialize :instrumentos_relacionados_historico

	enum resultado_admisibilidad: [:aceptado,:rechazado,:en_observación], _prefix: :resultado_admisibilidad
	enum resultado_pertinencia: [:aceptada,:solicita_condiciones,:realiza_observaciones,
															:solicita_condiciones_y_contiene_observaciones,:no_aceptada], _prefix: :resultado_pertinencia
	enum respuesta_resultado_pertinencia: [:aceptada, :solicita_condiciones_o_información, :no_aceptada], _prefix: :respuesta_resultado_pertinencia

	attr_accessor :revisor_id,:coordinador_subtipo_instrumento_id
	attr_accessor :accion_en_mapa_de_actores, :mapa_de_actores_correctamente_construido, :actores_con_observaciones
	attr_accessor :accion_en_documento_diagnostico, :aprueba_documentos_diagnostico, :documentos_diagnostico_con_observaciones
	attr_accessor :accion_en_set_metas_accion, :aprueba_set_metas_accion, :propuestas_con_observaciones
	mount_uploader :carta_de_interes_institucion_gestora_firmada, ArchivoCartasManifestacionDeInteresUploader
	mount_uploader :carta_de_apoyo_y_compromiso, ArchivoCartasManifestacionDeInteresUploader

	mount_uploader :estudios_sectoriales_territoriales_relevantes, ArchivoEstudiosSectorialesManifestacionDeInteresUploader

	mount_uploader :mapa_de_actores_archivo, ArchivoMapaDeActoresManifestacionDeInteresUploader

	mount_uploader :area_influencia_proyecto_archivo, ArchivoKmlKmzManifestacionDeInteresUploader
	mount_uploader :alternativas_instalacion_archivo, ArchivoKmlKmzManifestacionDeInteresUploader

	mount_uploader :estudio_de_mercado, ArchivoDocumentosGenericosManifestacionDeInteresUploader
	mount_uploader :anteproyecto, ArchivoDocumentosGenericosManifestacionDeInteresUploader
	mount_uploader :otros_estudios, ArchivoDocumentosGenericosManifestacionDeInteresUploader
	mount_uploader :otros_estudios_relevantes, ArchivoDocumentosGenericosManifestacionDeInteresUploader

	mount_uploader :gantt_proyecto, ArchivoGanttsOrganigramasManifestacionDeInteresUploader
	mount_uploader :organigrama, ArchivoGanttsOrganigramasManifestacionDeInteresUploader

	mount_uploader :archivo_admisibilidad, ArchivoAdmisibilidadesManifestacionDeInteresUploader
	mount_uploader :archivo_pertinencia_factibilidad, ArchivoPertinenciasFactibilidadesManifestacionDeInteresUploader
	mount_uploader :archivo_respuesta_pertinencia_factibilidad, ArchivoRespuestasPertinenciasFactibilidadesManifestacionDeInteresUploader
	mount_uploader :archivo_usuario_entregables, ArchivoUsuariosEntregablesManifestacionDeInteresUploader 
	mount_uploaders :firma_archivo, ArchivoFirmasManifestacionDeInteresUploader
	mount_uploader :archivo_carga_auditoria, ArchivoCargaAuditoriasManifestacionDeInteresUploader

	mount_uploader :archivo_acta_comite_informe, ArchivoActaComiteManifestacionDeInteresUploader

	mount_uploader :texto_apl, ArchivoDocumentosGenericosManifestacionDeInteresUploader


	before_validation :set_data_actecos
	before_validation :set_data_territorios

	validates :sectores_economicos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :territorios_regiones, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :caracterizacion_sector_territorio, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :tipo_instrumento_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :proponente, presence: true, on: :update, unless: -> { temporal.to_s == "true" } 
	validates :contribuyente_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :descripcion_acuerdo, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :carta_de_interes_institucion_gestora_firmada, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :proponente_institucion_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :caracterizacion_sector_territorio, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :principales_actores, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :mapa_de_actores_archivo, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :numero_empresas, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :porcentaje_mipymes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :produccion, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :ventas, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :porcentaje_exportaciones, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :principales_mercados, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :numero_trabajadores, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :vulnerabilidad_al_cambio_climatico_del_sector, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :principales_impactos_socioambientales_del_sector, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :principales_problemas_y_desafios, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :principales_conflictos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	#Validaciones datos del proyecto
	validates :nombre_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :descripcion_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :justificacion_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	#ya no usaran archivos kml
	# validates :area_influencia_proyecto_archivo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	# validates :alternativas_instalacion_archivo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :monto_inversion, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :tecnologia, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :estado_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :estudio_de_mercado, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :anteproyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :gantt_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :otros_estudios, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :operador, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :otros_proyectos_en_territorios_cercanos, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :otro_datos_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
	validates :nombre_acuerdo, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :motivacion_y_objetivos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :equipo_de_trabajo_comprometido, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :patrocinadores, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :monto_total_comprometido, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :organigrama, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :otros_recursos_comprometidos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :carta_de_apoyo_y_compromiso, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :numero_participantes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :lista_participantes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :priorizacion, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :otras_iniciativas_relacionadas_en_ejecucion, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	#validates :diagnostico_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	#validates :estandar_de_certificacion_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :otros_estudios_relevantes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :otros_objetivos_acuerdo, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

	validates :resultado_admisibilidad, presence: true, on: :update, if: -> {update_admisibilidad.present?}
	validates :respuesta_observaciones_admisibilidad, presence: true, on: :update, if: -> {update_obs_admisibilidad.present?}
	validate :is_observaciones_pertinencia_factibilidad, on: :update, if: -> { update_pertinencia.present? }
	validate :is_compromiso_pertinencia_factibilidad, on: :update, if: -> { update_pertinencia.present? }
	validate :pertinencia_secciones_observadas, on: :update, if: -> { update_pertinencia.present? }
	validates :coordinador_subtipo_instrumento_id, presence: true, on: :update, if: -> { resultado_pertinencia == "aceptada" && update_pertinencia.present?}
	validates :resultado_pertinencia, presence: true, on: :update, if: -> { update_pertinencia.present? }
	#validates :respuesta_resultado_pertinencia, presence: true, on: :update, if: -> { update_respuesta_pertinencia.present? } El campo ya no corresponde al apl-006
	validates :respuesta_observaciones_pertinencia_factibilidad, presence: true, on: :update, if: -> { update_respuesta_pertinencia.present? }
	validates :acepta_condiciones_pertinencia, inclusion: { in: [ true, false ] }, on: :update, if: -> { update_respuesta_pertinencia.present? && (resultado_pertinencia == "solicita_condiciones" || resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones")}

	validates :usuario_entregables_id, presence: true, on: :update, if: -> { update_usuario_entregables.present? }
	validates :usuario_entregables_comentario, presence: true, on: :update, if: -> { update_usuario_entregables.present? }

	validates :comentarios_y_observaciones_actualizacion_mapa_de_actores, presence: true, if: -> { temporal.to_s == "true" && mapa_de_actores_correctamente_construido.present? && mapa_de_actores_correctamente_construido == 'false' }
	validates :comentarios_y_observaciones_documento_diagnosticos, presence: true, if: -> { temporal.to_s == "true" && aprueba_documentos_diagnostico.present? && aprueba_documentos_diagnostico == 'false' }
	validates :comentarios_y_observaciones_set_metas_acciones, presence: true, if: -> { temporal.to_s == "true" && aprueba_set_metas_accion.present? && aprueba_set_metas_accion == 'false' }

	validate :data_mapa_de_actores, on: :update, if: -> { self.mapa_de_actores_archivo.present? }

	#apl-003 
	validates :observaciones_admisibilidad,presence: true, on: :update, if: -> {resultado_admisibilidad == "rechazado" || resultado_admisibilidad == "en_observación"}

	after_save :procesar_archivos_google_maps
	
	after_save :data_mapa_de_actores, if: -> { self.mapa_de_actores_archivo.present? }

	#DZC se indisponibiliza por necesidad de pasar @tarea_codigo al método, para la realización de validaciones de actores indispensables
	# after_save :parsear_mapa_de_actores

	def procesar_archivos_google_maps
		resultado = { area_influencia_proyecto_data: {}, alternativas_instalacion_data: {} }
		unless self.area_influencia_proyecto_archivo.blank?
			
		end

		unless self.alternativas_instalacion_archivo.blank?
			
		end
		 	
		resultado
	end

	def informe
		if self[:informe].nil?
			{
        "fundamentos"=>"", "antecedentes"=>"", "normativas_aplicables"=>"", "alcance"=>"", 
        "campo_de_aplicacion"=>"", "definiciones"=>"", "objetivo_general"=>"", 
        "objetivo_especifico"=>"", "mecanismo_de_implementacion"=>" ", "tipo_acuerdo"=>"", 
        "plazo_maximo_adhesion"=>"", "plazo_finalizacion_implementacion"=>"", 
        "mecanismo_evaluacion_cumplimiento"=>"", "plazo_maximo_neto"=>"", "plazo_maximo"=>"", 
        "adhesiones"=>"", "con_extension"=>"", "derechos"=>"", "obligaciones"=>"", 
        "difusion"=>"", "promocion"=>"", "incentivos"=>"", "sanciones"=>"", "personerias"=>"", 
        "ejemplares"=>"", "firmas"=>"", "anexos"=>""
      }
    else
    	self[:informe]
		end
	end

	def parsear_mapa_de_actores
		data = []
		unless self.mapa_de_actores_archivo.blank?
			header = [
        :rol_en_acuerdo,
        :rut_persona,
        :nombre_completo_persona,
        :cargo_en_institucion,
        :rut_institucion,
        :razon_social,
        :codigo_ciiuv2,
        :tipo_de_institucion,
        :direccion_institucion,
        :comuna_institucion,
        :email_institucional,
        :telefono_institucional
 			]
			data = ExcelParser.new(mapa_de_actores_archivo, header).tabulated #revisar necesidad de ingresar nombre mapa de archivo
	 	end
	 	data
	end

	def data_mapa_de_actores
		data = parsear_mapa_de_actores
		archivo_correcto = true
		if data.size <= 0
			errors.add(:mapa_de_actores_archivo, "Se debe indicar al menos un actor en el archivo")
			self.mapa_de_actores_archivo = nil
		else
			roles_minimos = MapaDeActor.roles_minimos_necesarios(self.tarea_codigo) unless self.tarea_codigo.blank?
			
			unless roles_minimos.blank? #DZC revisa que se cumpla con los roles minimos
				roles_correctos = true
				roles_minimos.each {|k, v|
					# DZC 2018-11-02 12:49:22 se corrige error en comparación de cantidad de roles mínimos
					roles_correctos = (data.select{|d| d[:rol_en_acuerdo]==k.to_s}.count < v) ? false : roles_correctos
				}	
				if !roles_correctos 
					errors.add(:mapa_de_actores_archivo, "El archivo no contiene la cantidad mínima de actores con roles específicos exigidos para esta tarea")
					archivo_correcto = false
				end
			end
			ruts_invalidos=[]
			emails_invalidos=[]
			telefonos_invalidos=[]
			dominios_invalidos=[]
			data.each_with_index do |fila, posicion|
				if fila.any?{|c|c.blank?}
					errors.add(:mapa_de_actores_archivo, "El archivo contiene celdas sin completar")
					archivo_correcto = false
				else
					validaciones = __validar_actor(fila)
					ruts_invalidos << validaciones[:ruts_invalidos] unless validaciones[:ruts_invalidos].nil?
					emails_invalidos << validaciones[:emails_invalidos] unless validaciones[:emails_invalidos].nil?
					telefonos_invalidos << validaciones[:telefonos_invalidos] unless validaciones[:telefonos_invalidos].nil?
					dominios_invalidos << validaciones[:dominios_invalidos] unless validaciones[:dominios_invalidos].nil?
					archivo_correcto = validaciones[:correcto] unless validaciones[:correcto].nil?
				end

				# DZC 2018-10-26 15:20:58 se reemplaza validación de eMail repetidos por validación eMail + RUT implementada por Ricardo 
				# validaciones del encargado
				emails = data.map{|d| d[:email_institucional]}
				if emails.include?(fila[:email_institucional])
					temp = data.map{|d| [d[:rut_persona],d[:email_institucional]]}
					#obtengo todos los que hacen match con el email
					temp_filtro = temp.select{|t| t.last == fila[:email_institucional]}
					#Verifico aquellos que tenga el mismo rut
					temp_final = temp_filtro.select{|t| t.first == fila[:rut_persona]}
					unless temp_filtro.size == temp_final.size
						errors.add(:mapa_de_actores_archivo, "Error en la línea #{(posicion+2)}. No se debe ingresar el mismo email a distintos usuarios")
						archivo_correcto = false
					end
				end
			end
			
			if ruts_invalidos.size > 0
				errors.add(:mapa_de_actores_archivo, "El archivo contiene #{ruts_invalidos.size} RUT(s) con errores: '#{ruts_invalidos.to_sentence}', por favor corregir")
				archivo_correcto = false
			else
				# DZC 2018-10-30 16:17:15 determina los ruts de los actores que tienen tareas pendientes en el flujo
				ruts_con_tareas_pendientes = self.flujo.ruts_actores_con_tareas_pendientes


				# DZC 2018-10-30 16:17:35 determina el rut de los actores que se incluyen en el archivo
				ruts_en_archivo = data.map{|d| d[:rut_persona]}

				# DZC 2018-10-30 16:17:55 determina el rut de los actores que no pueden eliminarse en el mapa de actores, y que subsistirán al poblamiento
				roles_no_eliminables = MapaDeActor.roles_no_actualizables(self.tarea_codigo)
				actores_no_eliminables_en_mapa = MapaDeActor.where(flujo_id: self.flujo, rol_id: roles_no_eliminables)
				personas_no_eliminables_en_mapa = Persona.where(id: actores_no_eliminables_en_mapa.pluck(:persona_id).uniq)
				usuarios_no_eliminables_en_mapa = User.where(id: personas_no_eliminables_en_mapa.pluck(:user_id).uniq)
				ruts_no_eliminables_en_mapa = usuarios_no_eliminables_en_mapa.pluck(:rut).uniq

				# DZC 2018-10-30 16:19:07 suma los ruts no eliminables a los que hay en el archivo, eliminando duplicados
				ruts_que_quedaran_en_mapa = (ruts_no_eliminables_en_mapa + ruts_en_archivo).uniq

				# DZC 2018-11-19 20:59:40 se corrige error en revisión de las tareas pendientes del revisor designado en APL-002
				unless ((ruts_con_tareas_pendientes & ruts_que_quedaran_en_mapa) == ruts_con_tareas_pendientes) || self.tarea_codigo == Tarea::COD_APL_001 || self.tarea_codigo == Tarea::COD_APL_002 || self.tarea_codigo == Tarea::COD_APL_003 || self.tarea_codigo == Tarea::COD_APL_004 || self.tarea_codigo == Tarea::COD_APL_005 || self.tarea_codigo == Tarea::COD_APL_006

					ruts_eliminados = ruts_con_tareas_pendientes - (ruts_con_tareas_pendientes & ruts_que_quedaran_en_mapa)
					errors.add(:mapa_de_actores_archivo, "No es posible procesar el archivo, pues no contiene al o los usuarios: #{User.nombre_por_rut(ruts_eliminados)} ; que mantiene(n) tarea(s) pendiente(s) sin terminar. Por favor corregir.")
					archivo_correcto = false
				end
			end
			
			if emails_invalidos.size > 0
				errors.add(:mapa_de_actores_archivo, "El archivo contiene #{emails_invalidos.size} Email(s) con errores: '#{emails_invalidos.to_sentence}', por favor corregir")
				archivo_correcto = false
			else

				# DZC 2018-10-26 15:20:58 se reemplaza validación de eMail repetidos por validación eMail + RUT implementada por Ricardo 
				# emails = data.map{|d|d[:email_institucional]}
				# repetidos = emails.uniq.size - emails.size
				# if repetidos != 0
				# 	errors.add(:mapa_de_actores_archivo, "El archivo contiene #{repetidos.abs} Emails repetidos, por favor indicar un correo distinto por cada actor")
				# 	archivo_correcto = false
				# end
			end

			if telefonos_invalidos.size > 0
				errors.add(:mapa_de_actores_archivo, "El archivo contiene #{telefonos_invalidos.size} Teléfono(s) con errores: '#{telefonos_invalidos.to_sentence}'; Por favor corregir")
				archivo_correcto = false
			end

			if archivo_correcto #DZC se mantiene el almacenamiento de data en el campo mapa_actores_data, para mantener la comparación de archivo 

				# self.mapa_de_actores_data = data
				self.mapa_de_actores_data = MapaDeActor.adecua_actores_para_vista(data)
				return true
			else
				
				self.mapa_de_actores_data = nil
				self.mapa_de_actores_archivo.remove!
				self.mapa_de_actores_archivo = nil
				return false
			end		
		end
	end

	def dominios_mapa_de_actores_validos?(fila)
		dominios = MapaDeActor.dominios

		roles_invalidos	= []
		cargos_invalidos	= []
		sectores_invalidos	= []
		tipo_instituciones_invalidos	= []
		comunas_invalidas	= []

		valores = {
			rol_en_acuerdo: :roles,
			cargo_en_institucion: :cargos,
			codigo_ciiuv2: :sectores,
			tipo_de_institucion: :tipo_instituciones,
			comuna_institucion: :comunas
		}

		header = [
        :rol_en_acuerdo,
        :rut_persona,
        :nombre_completo_persona,
        :cargo_en_institucion,
        :rut_institucion,
        :codigo_ciiuv2,
        :tipo_de_institucion,
        :direccion_institucion,
        :comuna_institucion,
        :email_institucional,
        :telefono_institucional
 			]
		valores.each do |campo,array|
			valor = fila[campo]
			unless dominios[array].include?(valor.to_s)
				if campo == :rol_en_acuerdo
					roles_invalidos << valor
				elsif campo == :cargo_en_institucion
					cargos_invalidos << valor
				elsif campo == :codigo_ciiuv2
					sectores_invalidos << valor
				elsif campo == :tipo_de_institucion
					tipo_instituciones_invalidos << valor
				elsif campo == :comuna_institucion
					comunas_invalidas << valor
				end
			end
		end
		
		no_hay_errores_con_los_dominios = true

		if roles_invalidos.size > 0
			errors.add(:mapa_de_actores_archivo, "Hay Roles inválidos, por favor corregir")
			no_hay_errores_con_los_dominios = false
		elsif cargos_invalidos.size > 0
			errors.add(:mapa_de_actores_archivo, "Hay Cargos inválidos, por favor corregir")
			no_hay_errores_con_los_dominios = false
		elsif sectores_invalidos.size > 0
			errors.add(:mapa_de_actores_archivo, "Hay Sectores inválidos, por favor corregir")
			no_hay_errores_con_los_dominios = false
		elsif tipo_instituciones_invalidos.size > 0
			errors.add(:mapa_de_actores_archivo, "Hay Tipo de instituciones inválidos, por favor corregir")
			no_hay_errores_con_los_dominios = false
		elsif comunas_invalidas.size > 0
			errors.add(:mapa_de_actores_archivo, "Hay Comunas inválidas, por favor corregir")
			no_hay_errores_con_los_dominios = false
		end

		no_hay_errores_con_los_dominios

	end
	def __validar_actor(fila)
		validaciones = {ruts_invalidos: nil, emails_invalidos: nil, telefonos_invalidos: nil, correcto: nil, completo: true}
		validaciones[:completo] = !fila.any?{|c|c.blank?}

		unless fila[:rut_persona].to_s.rut_valid?
			validaciones[:ruts_invalidos] = fila[:ruts_invalidos]
		end

		unless fila[:email_institucional].to_s.email_valid?
			validaciones[:emails_invalidos] = fila[:email_institucional]
		end

		# DZC 2018-10-20 21:05:30 se agrega la validación para el caso de que el rut y/o el eMail prexistan en la tabla de usuarios, en registros distintos
		if validaciones[:ruts_invalidos].nil? && validaciones[:emails_invalidos].nil?
			user = User.find_by(rut: fila[:rut_persona].to_s, email: fila[:email_institucional].to_s)
			if user.blank?
				if User.find_by(rut: fila[:rut_persona].to_s).present?
					validaciones[:ruts_invalidos] = "El RUT #{fila[:rut_persona]} ya existe en la base de datos de usuarios y dicho usuario tiene asociado otro eMail."
				end
				if User.find_by(email: fila[:email_institucional].to_s).present?
					validaciones[:emails_invalidos] = "El eMail #{fila[:email_institucional]} ya existe en la base de datos de usuarios y dicho usuario tiene asociado otro RUT."
				end
			end
		end

		unless fila[:rut_institucion].to_s.rut_valid?
			validaciones[:ruts_invalidos] = fila[:rut_institucion]
		end

		unless fila[:telefono_institucional].to_s.phone_valid?
			validaciones[:telefonos_invalidos] = fila[:telefono_institucional]
		end
		unless dominios_mapa_de_actores_validos?(fila)
			validaciones[:correcto] = false
		end
		# 
		validaciones
	end

	def set_data_actecos
		unless self.sectores_economicos.blank?
			self.sectores_economicos.delete("0")
		end
	end

	def set_data_territorios
		unless self.territorios_regiones.blank?
			self.territorios_regiones.delete("0")
		end
	end

	def set_checked
    rpc_checked = {territorios_regiones: {}, territorios_provincias: {}, territorios_comunas: {}}
    rpc_checked[:territorios_regiones] = self.territorios_regiones if self.territorios_regiones.is_a?(Hash)
    rpc_checked[:territorios_provincias] = self.territorios_provincias if self.territorios_provincias.is_a?(Hash)
    rpc_checked[:territorios_comunas] = self.territorios_comunas if self.territorios_comunas.is_a?(Hash)
    actecos_checked = self.sectores_economicos.is_a?(Hash) ? self.sectores_economicos : {}
    {
    	rpc_checked: rpc_checked,
    	actecos_checked: actecos_checked
    }
  end

  def atributos_agrupados
  	{ 
			"tipo-de-acuerdo": [
				:tipo_instrumento_id,
				:proponente,
				:contribuyente_id,
				:descripcion_acuerdo,
			],
			 "datos-institucion": [
			 	:institucion_gestora_acuerdo,
			 	:rut_institucion_gestora_acuerdo,
			 	:direccion_institucion_gestora_acuerdo,
			 	:lugar_institucion_gestora_acuerdo,
			 	:ubicacion_exacta,
			 	:tipo_contribuyente_de_institucion_gestora,
			 	:numero_de_socios_institucion_gestora,
				:fecha_creacion_institucion,
				:experiencia_en_gestion_de_proyectos,
				:nombre_representante_para_acuerdo,
				:rut_representante_para_acuerdo,
				:telefono_representante_para_acuerdo,
				:email_representante_para_acuerdo,
				:carta_de_interes_institucion_gestora_firmada,
			],
			"contexto-sector": [
				:sectores_economicos,
				:territorios_regiones,
				:caracterizacion_sector_territorio,
				:principales_actores,
				:numero_empresas,
				:porcentaje_mipymes,
				:produccion,
				:ventas,
				:porcentaje_exportaciones,
				:principales_mercados,
				:numero_trabajadores,
				:vulnerabilidad_al_cambio_climatico_del_sector,
				:principales_impactos_socioambientales_del_sector,
				:principales_problemas_y_desafios,
				:principales_conflictos,
				:otro_contexto_sector,
				:estudios_sectoriales_territoriales_relevantes,
				:mapa_de_actores_archivo,
			],
			"datos-proyecto": [
				:nombre_proyecto,
				:descripcion_proyecto,
				:justificacion_proyecto,
				#:area_influencia_proyecto_archivo,
				#:alternativas_instalacion_archivo,
				:monto_inversion,
				:tecnologia,
				:estado_proyecto,
				:estudio_de_mercado,
				:anteproyecto,
				:gantt_proyecto,
				:otros_estudios,
				:operador,
				:otros_proyectos_en_territorios_cercanos,
				:otro_datos_proyecto,
			],
			"objetivo-acuerdo": [
				:nombre_acuerdo,
				:motivacion_y_objetivos,
				:equipo_de_trabajo_comprometido,
				:patrocinadores,
				:monto_total_comprometido,
				:organigrama,
				:otros_recursos_comprometidos,
				:carta_de_apoyo_y_compromiso,
				:numero_participantes,
				:lista_participantes,
				:priorizacion,
				:otras_iniciativas_relacionadas_en_ejecucion,
				:diagnostico_id,
				:estandar_de_certificacion_id,
				:otros_estudios_relevantes,
				:otros_objetivos_acuerdo,
			],
			"admisibilidad": [
				:respuesta_observaciones_admisibilidad,
			],
			"pertinencia-factibilidad": [
				# :respuesta_observaciones_admisibilidad,
				:respuesta_observaciones_pertinencia_factibilidad,
			]
		}
  end

  def errores_agrupados
  	e = self.errors
  	ea = {}
  	atributos_agrupados.each do |grupo,atributos|
  		ea[grupo] = [] unless ea.has_key?(grupo)
  		atributos.each do |atributo|
  			ea[grupo] << atributo if e.has_key?(atributo)
  		end
  	end
  	ea
  end


  def self.format_campos(texto, valores)
		valores.each do |k, v|
			texto = texto.gsub("[#{key.to_s}]","#{v}", texto)
		end
		texto
  end

	def revisores_select
		# DZC 2018-10-03 17:41:49 se corrige la búsqueda de responsables según el tipo de instrumento de la instancia
		tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id
		Responsable.__personas_responsables(Rol.find_by(nombre: 'Revisor Técnico').id, tipo_instrumento_id).map{|p| [p.user.nombre_completo, p.id]} 		
	end

	def usuarios_entregables_select
		# DZC 2018-10-03 17:41:49 se corrige la búsqueda de responsables según el tipo de instrumento de la instancia
		tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id		
		Responsable.__personas_responsables(Rol.find_by(nombre: 'Responsable Entregables').id, tipo_instrumento_id).map{|p| [p.user.nombre_completo, p.id]}
	end

	def is_observaciones_pertinencia_factibilidad
		if  (self.resultado_pertinencia == "realiza_observaciones" || self.resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones") && self.observaciones_pertinencia_factibilidad.blank?
			errors.add(:observaciones_pertinencia_factibilidad, "Resultado de pertinencia requiere una observación")
		end
	end

	def is_compromiso_pertinencia_factibilidad
		if  (self.resultado_pertinencia == "solicita_condiciones" || self.resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones") && self.compromiso_pertinencia_factibilidad.blank?
			errors.add(:compromiso_pertinencia_factibilidad, "Resultado de pertinencia requiere compromiso")
		end
	end

	def pertinencia_secciones_observadas
		if self.resultado_pertinencia != "aceptada" && secciones_observadas_pertinencia_factibilidad.length == 1
			errors.add(:secciones_observadas_pertinencia_factibilidad, "Resultado de pertinencia requiere seleccionar pestañas con observaciones")
		end
	end

	def setear_documento_diagnosticos
    if self.documento_diagnosticos.size == 0
      self.documento_diagnosticos.build
    else
    	dd_array = []
    	self.documento_diagnosticos.each do |dd|
    		dd_array << dd
    	end
    	self.documento_diagnosticos = dd_array
    end
	end

	def tipo_manifestacion_metas
		if self.estandar_de_certificacion_id.present?
			tipo = 2
		elsif self.diagnostico_id.present?
			tipo = 3
		else
			tipo = 1
		end
	end

	def fecha_firma_formateada
		# DZC 2018-11-08 12:41:30 se modifica para el caso de que el campo tenga valor nil
		firma_fecha.blank? ? nil : (I18n.localize firma_fecha, format: :long)
		# I18n.localize firma_fecha, format: :long
	end
	def completar_informacion!
		#Completa la información de la institución cogestora cuando está cambia
		if self.contribuyente_id_changed?
			completar_institucion_cogestora
			self.representante = nil
		end
		if self.proponente_institucion_id_changed?
			verificar_es_cogestora
			self.representante = nil
		end
		if self.representante_institucion_para_solicitud_id_changed?
			completar_representate_institucion
		end		
	end
	def completar_institucion_cogestora
		contribuyente = self.contribuyente
		if contribuyente.present?
			self.flujo.update(contribuyente_id: contribuyente.id)
		  persona_de_contribuyente = self.current_user.personas.where(contribuyente_id: contribuyente.id).first
		  self.institucion_gestora_acuerdo = contribuyente.razon_social
		  self.rut_institucion_gestora_acuerdo = contribuyente.rut_completo
		  self.tipo_contribuyente_de_institucion_gestora = contribuyente.tipo_contribuyente
		  
		  casa_matriz = contribuyente.direccion_casa_matriz(false,true)
		  self.direccion_institucion_gestora_acuerdo = casa_matriz.inject(""){|s,(k,v)| s+= "#{v} " unless v.blank?; s}.strip
		  self.lugar_institucion_gestora_acuerdo = casa_matriz[:comuna]
		  if casa_matriz.is_a?(Hash) && ! casa_matriz[:comuna].blank? && self.ubicacion_exacta.blank?
		    coordinates = GeoLocalization.get_coordinates(casa_matriz[:direccion],"#{casa_matriz[:comuna]} #{casa_matriz[:region]}",casa_matriz[:pais])
		    self.ubicacion_exacta = "#{coordinates.map{|k,v|v}.join(",")}"
		  end
		else
			self.flujo.update(contribuyente_id: nil)
		  self.institucion_gestora_acuerdo = nil
		  self.rut_institucion_gestora_acuerdo = nil
		  self.tipo_contribuyente_de_institucion_gestora = nil
		  self.direccion_institucion_gestora_acuerdo = nil
		  self.lugar_institucion_gestora_acuerdo = nil
		  self.ubicacion_exacta = nil
		end
	end
	def completar_representate_institucion
		representante = self.representante
		if representante.present?
			self.nombre_representante_para_acuerdo = representante.nombre_completo
			self.rut_representante_para_acuerdo = representante.rut
			self.telefono_representante_para_acuerdo = representante.telefono
			self.email_representante_para_acuerdo = representante.email
		else
			self.nombre_representante_para_acuerdo = nil
			self.rut_representante_para_acuerdo = nil
			self.telefono_representante_para_acuerdo = nil
			self.email_representante_para_acuerdo = nil
		end
	end
	def verificar_es_cogestora
		tipo_instrumento_id = self.tipo_instrumento_id.present? ? self.tipo_instrumento_id : TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA
		if self.proponente_institucion_id.present?
			es_cogestora = Responsable.__instituciones_con_rol(Rol::COGESTOR, tipo_instrumento_id, self.proponente_institucion_id)
			if es_cogestora
				self.contribuyente_id	= self.proponente_institucion_id
				self.flujo.update(contribuyente_id: self.contribuyente_id)
				completar_institucion_cogestora
			else
				self.contribuyente_id	= nil
				self.flujo.update(contribuyente_id: nil)
				completar_institucion_cogestora
			end
		end
	end

	def self.con_diagnostico
		self.where('diagnostico_fecha_termino IS NOT NULL').map{|m|[m.nombre_acuerdo,m.id]}
	end

	def comentarios_diagnostico_ordenados
		self.comentarios_y_observaciones_documento_diagnosticos.present? ? 
			self.comentarios_y_observaciones_documento_diagnosticos.sort_by{|c| c[:datetime]}.reverse : []
	end

	# DZC 2018-11-02 15:48:33 devuelve el listado de personas para seleccion.
  def usuarios_para_lista(rol, contribuyente_id=nil)
  	# DZC 2018-10-03 18:28:31 se modifica lectura de tipo_instrumento_id al flujo correspondiente, para evitar valores nulos
	  tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id

  	# tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id
  	personas = Responsable.__personas_responsables(rol, tipo_instrumento_id).uniq
  	
  	if !contribuyente_id.blank?
  		personas.map!{|p| p if p[:contribuyente_id] == contribuyente_id}
  		personas = personas.compact
  	end
  	personas
  end

end
