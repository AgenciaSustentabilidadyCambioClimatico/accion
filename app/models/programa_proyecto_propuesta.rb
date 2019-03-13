class ProgramaProyectoPropuesta < ApplicationRecord

	# DZC 2019-03-01 11:36:03 tiempo para mostrar el mensaje de guardar
	MINUTOS_MENSAJE_GUARDAR = 20

	has_one :flujo, dependent: :destroy
	belongs_to :representante, optional: true, foreign_key: :representante_institucion_para_solicitud_id, class_name: :User
	belongs_to :institucion_gestora, optional: true, foreign_key: :institucion_que_solicita_apoyo_id, class_name: :Contribuyente
	has_many :ppf_actividad
	accepts_nested_attributes_for :ppf_actividad, allow_destroy: true
	has_many :adhesiones, through: :flujo, foreign_key: :flujo_id

	ACEPTADA = 0
	RECHAZADA = 1
	CON_OBSERVACIONES = 2

#	attr_accessor :current_tab, :temporal, :current_user, :no_es_ejecutado_por_terceros, :forzar_validacion_en
#DZC Gino
	# DZC 2018-10-24 15:55:42 se agregan :revisor_id, :responsable_coordinacion_postulacion_y_seguimiento_id, :responsable_coordinacion_ejecucion_seguimiento_id, :usuario_visitas_id y usuario_carga_datos_id a efecto de traspasar el rol al mapa de actores y permitir la eliminación de la persona asociada al usuario.
	attr_accessor(
		:current_tab,
		:temporal,
		:current_user,
		:no_es_ejecutado_por_terceros,
		:forzar_validacion_en,
		:actual_comentarios_observaciones_tecnicas,
		:accion_en_set_metas_accion,
		:revisor_id, 
		:responsable_coordinacion_postulacion_y_seguimiento_id,
		:responsable_elaboracion_propuesta_y_seguimiento_id,
		:responsable_coordinacion_ejecucion_seguimiento_id,
		:usuario_visitas_id,
		:usuario_carga_datos_id
	)

	has_many :ejecucion_presupuestarias, foreign_key: :programa_proyecto_propuesta_id, dependent: :destroy
	accepts_nested_attributes_for :ejecucion_presupuestarias, allow_destroy: true
#DZC

	serialize :secciones_observadas_revision
	serialize :historia_respuesta_proponente_revision
	serialize :historia_observaciones_y_comentarios_revision
#DZC Gino
	serialize :comentarios_observaciones_tecnicas
	serialize :comentarios_visitas
	serialize :comentarios_carga_datos
	serialize :sectores_economicos	
#RDO
	serialize :territorios_regiones
	serialize :territorios_provincias
	serialize :territorios_comunas
	serialize :instrumentos_relacionados_historico
	belongs_to :instrumento_relacionado, polymorphic: true, optional: true #DZC 2018-10-08 17:29:43 se agrega para efectos de la primera vez que se guarda el PPF 

#	enum resultado_revision: [:aceptado,:rechazado,:en_observación], _prefix: :resultado_admisibilidad
#DZC Gino
	enum resultado_revision: [:aceptado,:rechazado,:con_observaciones], _prefix: :revision
	enum resultado_observaciones_tecnica: [:a_postulación,:desechado,:con_observaciones]
	enum resultado_postulaciones: [:aceptado,:rechazado], _prefix: :postulacion
#DZC

	has_many :set_metas_acciones
	belongs_to :ppf, optional: true, foreign_key: :tipo_instrumento_id, class_name: :TipoInstrumento
	belongs_to :proponente_, optional: true, foreign_key: :proponente_id, class_name: :User
	belongs_to :representante, optional: true, foreign_key: :representante_institucion_para_solicitud_id, class_name: :User
	belongs_to :contribuyente, optional: true, foreign_key: :institucion_que_solicita_apoyo_id, class_name: :Contribuyente
	belongs_to :institucion_a_la_cual_se_presentara, optional: true, foreign_key: :institucion_a_la_cual_se_presentara_la_propuesta_id, class_name: :Contribuyente
	belongs_to :sucursal_institucion_a_la_cual_se_presentara, optional: true, foreign_key: :sucursal_institucion_a_la_cual_se_presentara_la_propuesta_id, class_name: :EstablecimientoContribuyente
	belongs_to :ppp_base, optional: true, foreign_key: :programa_proyecto_propuesta_base_id, class_name: :ProgramaProyectoPropuesta
	#DZC agregado por nosotros
	belongs_to :tipo_instrumento, foreign_key: 'tipo_instrumento_id', optional: true
#DZC Gino
	belongs_to :organismo_ejecutor, optional: true, foreign_key: :organismo_ejecutor_id, class_name: :Contribuyente
	belongs_to :institucion_visitas, optional: true, foreign_key: :institucion_visitas_id, class_name: :Contribuyente
	belongs_to :institucion_carga_datos, optional: true, foreign_key: :institucion_carga_datos_id, class_name: :Contribuyente
#DZC

	mount_uploader :documento_con_programa_proyecto_existente, GenericoUploader
	mount_uploader :documento_proponente_revision, GenericoUploader
	mount_uploader :documento_productos_resultados, GenericoUploader
#DZC Gino
	mount_uploader :carta_de_apoyo_coordinador, GenericoUploader
	mount_uploader :documento_proyecto, GenericoUploader
	mount_uploader :documento_resultados, GenericoUploader
	mount_uploader :archivo_propuesta_elaboracion, DocumentoConProgramaProyectoExistenteUploader
	mount_uploader :archivo_observaciones_tecnicas, GenericoUploader

	mount_uploader :documento_recepcion_postulacion, DocumentoConProgramaProyectoExistenteUploader
	mount_uploader :documentos_administrativos_aprobando_el_proyecto, GenericoUploader
#DZC

	validates :tipo_instrumento_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :proponente_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :proponente, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :descripcion, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

 	validates :institucion_que_solicita_apoyo_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :rut_institucion_que_solicita_apoyo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :direccion_institucion_que_solicita_apoyo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :lugar_institucion_que_solicita_apoyo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :ubicacion_exacta_institucion_que_solicita_apoyo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :tipo_contribuyente_institucion_que_solicita_apoyo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :nombre_representante_institucion_para_solicitud, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :rut_representante_institucion_para_solicitud, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :telefono_representante_institucion_para_solicitud, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }
	validates :email_representante_institucion_para_solicitud, presence: true, on: :update, unless: -> { temporal.to_s == "true" || no_es_ejecutado_por_terceros }

 	validates :nombre_propuesta, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :motivacion_y_objetivos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :equipo_de_trabajo_comprometido, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :instituciones_participantes_propuesta, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :monto_aproximado_a_solicitar, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :fecha_aproximada_postulacion, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :fecha_aproximada_decision, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :motivos_relevantes_para_postular, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :instrumento_relacionado, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :institucion_a_la_cual_se_presentara_la_propuesta_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :nombre_del_fondo_al_cual_se_esta_postulando, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
	validates :documento_con_programa_proyecto_existente, presence: true, on: :update, unless: -> { temporal.to_s == "true" }, if: -> {tipo_instrumento_id.present? && tipo_instrumento_id == TipoInstrumento::PPP_EJECUTADOS_POR_TERCEROS}
	#validates :programa_proyecto_propuesta_base_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

	validates :revisor_id, presence: true, on: :update, if: -> { forzar_validacion_en == :asignar_revisor }

	validates :resultado_de_la_revision, presence: true, on: :update, if: -> { forzar_validacion_en == :revision }
	validate :data_secciones_observadas_revision, on: :update, if: -> { forzar_validacion_en == :revision }
	validates :actual_observaciones_y_comentarios_revision, presence: true, on: :update, if: -> { forzar_validacion_en == :revision && self.resultado_de_la_revision == ProgramaProyectoPropuesta::CON_OBSERVACIONES }
	validates :responsable_coordinacion_postulacion_y_seguimiento_id, presence: true, on: :update, if: -> { forzar_validacion_en == :revision && self.resultado_de_la_revision == ProgramaProyectoPropuesta::ACEPTADA }
	validates :responsable_elaboracion_propuesta_y_seguimiento_id, presence: true, on: :update, if: -> { forzar_validacion_en == :revision && self.resultado_de_la_revision == ProgramaProyectoPropuesta::ACEPTADA && self.tipo_instrumento_id == TipoInstrumento::PPP_PROPUESTOS_Y_EJECUTADOS_POR_AGENCIA}

	validates :actual_respuesta_proponente_revision, presence: true, on: :update, if: -> { (temporal.blank? || temporal.to_s == "false") && forzar_validacion_en == :resolver_observaciones }

	before_validation :verificar_si_es_ejecutado_por_terceros

	before_save :update_historia_comentarios, on: :update, if: -> { forzar_validacion_en == :revision || forzar_validacion_en == :resolver_observaciones }
	before_save :set_revision_aceptada, on: :update, if: -> { forzar_validacion_en == :revision && self.resultado_de_la_revision == ProgramaProyectoPropuesta::ACEPTADA }

#DZC Gino
	validates :carta_de_apoyo_coordinador, presence: true, on: :update, if: -> { (temporal.blank? || temporal.to_s == "false") && forzar_validacion_en == :carta_de_apoyo }

	validates :proyecto_adjudicado, presence: true, on: :update, if: -> { forzar_validacion_en == :seguimiento_a_terceros && proyecto_adjudicado != false }
	validates :motivos_adjudicacion, presence: true, on: :update, if: -> { obligatorio_cuando_adjudicado_es?(false) }
	validates :fecha_adjudicacion, presence: true, on: :update, if: -> { obligatorio_cuando_adjudicado_es?(true) }
	validates :monto_adjudicado, presence: true, on: :update, if: -> { obligatorio_cuando_adjudicado_es?(true) }
	validates :monto_adjudicado, numericality: { only_integer: true }, if: -> { obligatorio_cuando_adjudicado_es?(true) } #Valida que un numero valido
	validates :fecha_inicio, presence: true, on: :update, if: -> { obligatorio_cuando_adjudicado_es?(true) }
	validates :fecha_finalizacion, presence: true, on: :update, if: -> { obligatorio_cuando_adjudicado_es?(true) }
	validates :enlace_proyecto, http_url: true, on: :update, if: -> { enlace_proyecto.present? && obligatorio_cuando_adjudicado_es?(true) }
	validate :fecha_adjudicacion_debe_ser_igual_o_menor_a_fecha_inicio, on: :update, if: -> { obligatorio_cuando_adjudicado_es?(true) }
	validate :fecha_finalizacion_debe_ser_mayor_a_fecha_inicio, on: :update, if: -> { obligatorio_cuando_adjudicado_es?(true) }

	validates :archivo_propuesta_elaboracion, presence: true, on: :update, if: -> { forzar_validacion_en == :elaboracion_inicial_propuesta }

	validates :actual_comentarios_observaciones_tecnicas, presence: true, on: :update, if: -> { forzar_validacion_en == :observaciones_tecnicas }
	validates :archivo_observaciones_tecnicas, presence: true, on: :update, if: -> { forzar_validacion_en == :observaciones_tecnicas }
	validates :fecha_observaciones_tecnicas, presence: true, on: :update, if: -> { forzar_validacion_en == :observaciones_tecnicas }
	validates :resultado_observaciones_tecnicas, presence: true, on: :update, if: -> { forzar_validacion_en == :observaciones_tecnicas }

	before_save :update_comentarios_observaciones_tecnicas, on: :update, if: -> { forzar_validacion_en == :observaciones_tecnicas }

	validates :fecha_postulacion, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :documento_recepcion_postulacion, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :resultado_postulacion, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :fecha_entrega_resultados, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :motivos_resultado, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion && resultado_postulacion == 1 }
	validates :monto_aprobado, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :organismo_ejecutor_id, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :responsable_coordinacion_ejecucion_seguimiento_id, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :documentos_administrativos_aprobando_el_proyecto, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :fecha_inicio_legal_proyecto, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :codigo_bip, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validates :plazo_ejecucion_legal, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validate :fecha_postulacion_debe_ser_menor_o_igual_a_hoy, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validate :fecha_entrega_resultados_debe_ser_mayor_o_igual_a_fecha_postulacion, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	validate :fecha_inicio_legal_proyecto_debe_ser_mayor_o_igual_a_fecha_postulacion, on: :update, if: -> { forzar_validacion_en == :datos_postulacion }
	

	validates :fecha_inicio_efectiva, presence: true, on: :update, if: -> { forzar_validacion_en == :seguimiento_proyecto }
	#Ya no es obligatorio
	#validates :fecha_finalizacion_efectiva, presence: true, on: :update, if: -> { forzar_validacion_en == :seguimiento_proyecto }
	validates :participacion_agencia, presence: true, on: :update, if: -> { forzar_validacion_en == :seguimiento_proyecto }
	validates :productos_y_resultados, presence: true, on: :update, if: -> { forzar_validacion_en == :seguimiento_proyecto }

	# validates :institucion_visitas_id, presence: true, on: :update, if: -> { forzar_validacion_en == :asignar_usuarios_a_cargo_ejecucion_programa }
	validates :usuario_visitas_id, presence: true, on: :update, if: -> { forzar_validacion_en == :asignar_usuarios_a_cargo_ejecucion_programa }
	validates :comentarios_visitas, presence: true, on: :update, if: -> { forzar_validacion_en == :asignar_usuarios_a_cargo_ejecucion_programa }
	# validates :institucion_carga_datos_id, presence: true, on: :update, if: -> { forzar_validacion_en == :asignar_usuarios_a_cargo_ejecucion_programa }
	validates :usuario_carga_datos_id, presence: true, on: :update, if: -> { forzar_validacion_en == :asignar_usuarios_a_cargo_ejecucion_programa }
	validates :comentarios_carga_datos, presence: true, on: :update, if: -> { forzar_validacion_en == :asignar_usuarios_a_cargo_ejecucion_programa }

	before_validation :set_data_actecos, if: -> { forzar_validacion_en == :datos_ejecucion_presupuestaria_anual }
	validates :sectores_economicos, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_ejecucion_presupuestaria_anual }
	validates :proyecto_con_atencion_directa_a_beneficiarios, presence: true, on: :update, if: -> { forzar_validacion_en == :datos_ejecucion_presupuestaria_anual && proyecto_con_atencion_directa_a_beneficiarios != false  }
	#validar que la fecha de de decision sea mayor que la de postulacion
	validate :fecha_de_decision_mayor_postulacion, if: -> {fecha_aproximada_postulacion.present? && fecha_aproximada_decision.present?}

  def fecha_de_decision_mayor_postulacion
    if fecha_aproximada_decision < fecha_aproximada_postulacion
    	#fecha_aproximada_decision = nil
      errors.add(:fecha_aproximada_decision, "Fecha de desicion no puede ser inferior a la fecha de postulacion")
    end
  end 
#DZC
	def completar_informacion!
		#Completa la información de la institución cogestora cuando está cambia
		if self.institucion_que_solicita_apoyo_id_changed? || tipo_instrumento_id_changed?
			completar_institucion_cogestora
			self.representante_institucion_para_solicitud_id = nil
		end
		if self.representante_institucion_para_solicitud_id_changed?
			completar_representate_institucion
		end
		
    unless self.ppf.blank?
      self.descripcion = self.ppf.descripcion
    end
	end

	def llenar_cuando_institucion_exista
	  contribuyente = self.contribuyente
	  self.nombre_representante_institucion_para_solicitud = self.current_user.nombre_completo
	  self.rut_representante_institucion_para_solicitud = self.current_user.rut
	  
	  persona_de_contribuyente = self.current_user.personas.where(contribuyente_id: contribuyente.id).first
	  # self.email_representante_institucion_para_solicitud = persona_de_contribuyente.email_institucional rescue binding.pry
	  # DZC 2018-10-05 11:09:07 se elimina el rescue
	  self.email_representante_institucion_para_solicitud = persona_de_contribuyente.email_institucional
	  self.telefono_representante_institucion_para_solicitud = persona_de_contribuyente.telefono_institucional
	  #self.nombre_institucion_que_solicita_apoyo = contribuyente.razon_social
	  self.rut_institucion_que_solicita_apoyo = contribuyente.rut_completo
	  actecos = contribuyente.actividad_economica_contribuyentes.map{|m|m.actividad_economica}
	  self.tipo_contribuyente_institucion_que_solicita_apoyo = actecos.blank? ? nil : actecos.first.id
	  
	  casa_matriz = contribuyente.direccion_casa_matriz(false,true)
	  self.direccion_institucion_que_solicita_apoyo = casa_matriz.inject(""){|s,(k,v)| s+= "#{v} " unless v.blank?; s}.strip
	  self.lugar_institucion_que_solicita_apoyo = casa_matriz[:comuna]
	  if casa_matriz.is_a?(Hash) && ! casa_matriz[:comuna].blank? && self.ubicacion_exacta_institucion_que_solicita_apoyo.blank?
	    coordinates = GeoLocalization.get_coordinates(casa_matriz[:direccion],"#{casa_matriz[:comuna]} #{casa_matriz[:region]}",casa_matriz[:pais])
	    self.ubicacion_exacta_institucion_que_solicita_apoyo = "#{coordinates.map{|k,v|v}.join(",")}"
	  end
	end

	def completar_institucion_cogestora
		# 
		# DZC 2018-10-24 10:42:00 se modifica el método para manejar la posibilidad de que el contribuyente sea nulo, en cuyo caso se utilizan los datos de la agencia
		# DZC 2018-11-26 15:09:20 se modifica para que en caso de que el tipo de instrumento sea PPP_PROPUESTOS_AGENCIA_Y_EJECUTADOS_TERCEROS, el contribuyente se deja en nil
		unless self.contribuyente.blank? && self.tipo_instrumento_id != TipoInstrumento::PPP_EJECUTADOS_POR_TERCEROS
			contribuyente = self.contribuyente
		else
			contribuyente = Contribuyente.find_by(rut: 75980060) #DZC 2018-10-24 10:43:47 se busca a la ASCC por su RUT
		end
		unless self.contribuyente.blank?
			self.flujo.update(contribuyente_id: contribuyente.id)
		  persona_de_contribuyente = self.current_user.personas.where(contribuyente_id: contribuyente.id).first
		  self.rut_institucion_que_solicita_apoyo = contribuyente.rut_completo
		  self.tipo_contribuyente_institucion_que_solicita_apoyo = contribuyente.tipo_contribuyente
		  
		  casa_matriz = contribuyente.direccion_casa_matriz(false,true)
		  self.direccion_institucion_que_solicita_apoyo = casa_matriz.inject(""){|s,(k,v)| s+= "#{v} " unless v.blank?; s}.strip
		  self.lugar_institucion_que_solicita_apoyo = casa_matriz[:comuna]
		  if casa_matriz.is_a?(Hash) && ! casa_matriz[:comuna].blank? && self.ubicacion_exacta_institucion_que_solicita_apoyo.blank?
		    coordinates = GeoLocalization.get_coordinates(casa_matriz[:direccion],"#{casa_matriz[:comuna]} #{casa_matriz[:region]}",casa_matriz[:pais])
		    self.ubicacion_exacta_institucion_que_solicita_apoyo = "#{coordinates.map{|k,v|v}.join(",")}"
		  end
		end
	end

	def completar_representate_institucion
		representante = self.representante
		if representante.present?
			self.nombre_representante_institucion_para_solicitud = representante.nombre_completo
			self.rut_representante_institucion_para_solicitud = representante.rut
			self.telefono_representante_institucion_para_solicitud = representante.telefono
			self.email_representante_institucion_para_solicitud = representante.email
		else
			self.nombre_representante_institucion_para_solicitud = nil
			self.rut_representante_institucion_para_solicitud = nil
			self.telefono_representante_institucion_para_solicitud = nil
			self.email_representante_institucion_para_solicitud = nil
		end
	end

	def verificar_si_es_ejecutado_por_terceros
		self.no_es_ejecutado_por_terceros = ( self.tipo_instrumento_id.present? && self.tipo_instrumento_id != TipoInstrumento::PPP_EJECUTADOS_POR_TERCEROS )
	end

	def propuesto_ejecutado_por_agencia?
		( self.tipo_instrumento_id.present? && self.tipo_instrumento_id == TipoInstrumento::PPP_PROPUESTOS_Y_EJECUTADOS_POR_AGENCIA )
	end

	def data_secciones_observadas_revision
		if self.resultado_de_la_revision == ProgramaProyectoPropuesta::CON_OBSERVACIONES
			_secciones_observadas_revision = {
				tipo_de_propuesta: false,
				datos_institucion: false,
				objetivo_propuesta: false,
			}
			
			unless self.secciones_observadas_revision.blank?
				self.secciones_observadas_revision.reject{|r|r.blank?}.each do |seccion|
					_secciones_observadas_revision[seccion.to_sym] = true
				end
			end

			if _secciones_observadas_revision.reject{|k,v|v==false}.size == 0
				error_message = I18n.t('activerecord.errors.models.programa_proyecto_propuesta.attributes.secciones_observadas_revision.blank')
				errors.add(:secciones_observadas_revision, error_message)
			end
		elsif self.resultado_de_la_revision == ProgramaProyectoPropuesta::ACEPTADA
			self.secciones_observadas_revision = []
		end
	end

	def update_historia_comentarios
		# Observaciones y comentarios
		if self.historia_observaciones_y_comentarios_revision.blank?
			self.historia_observaciones_y_comentarios_revision = []
		end

		unless self.actual_observaciones_y_comentarios_revision.blank?
			self.historia_observaciones_y_comentarios_revision << set_nuevo_comentario(self.actual_observaciones_y_comentarios_revision,self.secciones_observadas_revision)
			self.actual_observaciones_y_comentarios_revision = nil
		end

		# Respuestas proponente
		if self.historia_respuesta_proponente_revision.blank?
			self.historia_respuesta_proponente_revision = []
		end

		unless self.actual_respuesta_proponente_revision.blank?
			if historia_observaciones_y_comentarios_revision.present?
				data = historia_observaciones_y_comentarios_revision.last["data"]
			else
				data = nil
			end
			self.historia_respuesta_proponente_revision << set_nuevo_comentario(self.actual_respuesta_proponente_revision, data)
			self.actual_respuesta_proponente_revision = nil
		end
	end

#DZC Gino
	def update_comentarios_observaciones_tecnicas
		if self.comentarios_observaciones_tecnicas.blank?
			self.comentarios_observaciones_tecnicas = []
		end

		unless self.actual_comentarios_observaciones_tecnicas.blank?
			self.comentarios_observaciones_tecnicas << set_nuevo_comentario(self.actual_comentarios_observaciones_tecnicas)
			self.actual_comentarios_observaciones_tecnicas = nil
		end
	end
#DZC
	def set_revision_aceptada
		self.resuelta = true
	end

#DZC Gino
	def obligatorio_cuando_adjudicado_es?(booleano)
		( (temporal.blank? || temporal.to_s == "false") && forzar_validacion_en == :seguimiento_a_terceros && proyecto_adjudicado == booleano )
	end

	def fecha_adjudicacion_debe_ser_igual_o_menor_a_fecha_inicio
		unless fecha_inicio.blank? || fecha_adjudicacion.blank?
			unless fecha_inicio >= fecha_adjudicacion
				errors.add(:fecha_inicio, I18n.t(:fecha_inicio_debe_ser_igual_o_mayor_a_fecha_adjudicacion))
				errors.add(:fecha_adjudicacion, I18n.t(:fecha_adjudicacion_debe_ser_igual_o_menor_a_fecha_inicio))
			end
		end
	end

	def fecha_finalizacion_debe_ser_mayor_a_fecha_inicio
		unless fecha_finalizacion.blank? || fecha_inicio.blank?
			#fi = DateTime.parse(fecha_inicio.to_s)
			#ff = DateTime.parse(fecha_finalizacion.to_s)
			unless fecha_finalizacion > fecha_inicio
				errors.add(:fecha_finalizacion, I18n.t(:fecha_finalización_debe_ser_mayor_a_fecha_inicio))
				errors.add(:fecha_inicio, I18n.t(:fecha_inicio_debe_ser_menor_a_fecha_finalización))
			end
		end
	end

	def fecha_postulacion_debe_ser_menor_o_igual_a_hoy
		unless fecha_postulacion.blank? || fecha_postulacion <= Date.today
			errors.add(:fecha_postulacion, I18n.t(:fecha_postulación_debe_ser_menor_o_igual_a_hoy))
		end
	end

	def fecha_entrega_resultados_debe_ser_mayor_o_igual_a_fecha_postulacion
		unless fecha_entrega_resultados.blank? || fecha_postulacion.blank? || fecha_entrega_resultados >= fecha_postulacion
			errors.add(:fecha_entrega_resultados, I18n.t(:fecha_entrega_resultados_debe_ser_mayor_o_igual_a_fecha_postulación))
		end
	end

	def fecha_inicio_legal_proyecto_debe_ser_mayor_o_igual_a_fecha_postulacion
		unless fecha_inicio_legal_proyecto.blank? || fecha_postulacion.blank? || fecha_inicio_legal_proyecto >= fecha_postulacion
			errors.add(:fecha_inicio_legal_proyecto, I18n.t(:fecha_inicio_legal_proyecto_debe_ser_mayor_o_igual_a_fecha_postulación))
		end
	end
#DZC
	def set_nuevo_comentario(texto,data=[])
		{
			usuario: current_user.nombre_completo,
			fecha_y_hora: DateTime.now,
			texto: texto,
			data: data
		}
	end
#DZC Gino
	def set_data_actecos
		unless self.sectores_economicos.blank?
			self.sectores_economicos.delete("0")
		end
	end

	def checked_sectores_economicos
    self.sectores_economicos.is_a?(Hash) ? self.sectores_economicos : {}
  end
#DZC

	def self.atributos_agrupados
  	{ 
			"tipo-de-propuesta": [
				:tipo_instrumento_id,
				:proponente_id,
				:proponente,
				:descripcion,
			],
			 "datos-institucion": [
			 	:institucion_que_solicita_apoyo_id,
				#:nombre_institucion_que_solicita_apoyo,
				:rut_institucion_que_solicita_apoyo,
				:direccion_institucion_que_solicita_apoyo,
				:lugar_institucion_que_solicita_apoyo,
				:ubicacion_exacta_institucion_que_solicita_apoyo,
				:tipo_contribuyente_institucion_que_solicita_apoyo,
				:nombre_representante_institucion_para_solicitud,
				:rut_representante_institucion_para_solicitud,
				:telefono_representante_institucion_para_solicitud,
				:email_representante_institucion_para_solicitud,
			],
			"objetivo-propuesta": [
				:nombre_propuesta,
				:motivacion_y_objetivos,
				:equipo_de_trabajo_comprometido,
				:instituciones_participantes_propuesta,
				:monto_aproximado_a_solicitar,
				:fecha_aproximada_postulacion,
				:fecha_aproximada_decision,
				:motivos_relevantes_para_postular,
				:instrumento_relacionado,
				:institucion_a_la_cual_se_presentara_la_propuesta_id,
      	:sucursal_institucion_a_la_cual_se_presentara_la_propuesta_id,
				:nombre_del_fondo_al_cual_se_esta_postulando,
				:documento_con_programa_proyecto_existente,
				:programa_proyecto_propuesta_base_id,
			],
			"revision-propuesta": [
				:resultado_de_la_revision,
	      :actual_observaciones_y_comentarios_revision,
	      :responsable_coordinacion_postulacion_y_seguimiento_id,
	      :responsable_elaboracion_propuesta_y_seguimiento_id,
	      :secciones_observadas_revision
			],
			"resolver-observaciones": [
				:actual_respuesta_proponente_revision
			]
		}
  end

  def errores_agrupados
  	e = self.errors
  	ea = {}
  	ProgramaProyectoPropuesta.atributos_agrupados.each do |grupo,atributos|
  		ea[grupo] = [] unless ea.has_key?(grupo)
  		atributos.each do |atributo|
  			ea[grupo] << atributo if e.has_key?(atributo)
  		end
  	end
  	ea
  end

  #DZC devuelve el resultado de la revisión como texto
  def resultado_revision_texto
  	ProgramaProyectoPropuesta.resultado_revisiones.keys.each_with_index.map { |w,k| [w.humanize, k]}[self.resultado_de_la_revision][0]
  end

  #DZC devuelve el resultado de las observaciones técnicas como texto
  def resultado_observaciones_tecnicas_texto
  	ProgramaProyectoPropuesta.resultado_observaciones_tecnicas.keys.each_with_index.map { |w,k| [w.humanize, k]}[self.resultado_observaciones_tecnicas][0]
  end

  #DZC devuelve el resultado de la postulación como texto
  def resultado_postulacion_texto
  	ProgramaProyectoPropuesta.resultado_postulaciones.keys.each_with_index.map {|w,k|[w.humanize,k]}[self.resultado_postulacion][0]
  end

  #DZC devuelve el listado de usuarios para seleccion
  def usuarios_para_lista(rol, contribuyente_id=nil)
  	# DZC 2018-10-03 18:28:31 se modifica lectura de tipo_instrumento_id al flujo correspondiente, para evitar valores nulos
  	tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id
  	personas = Responsable.__personas_responsables(rol, tipo_instrumento_id).uniq
  	
  	if !contribuyente_id.blank?
  		personas.map!{|p| p if p[:contribuyente_id] == contribuyente_id}
  		personas = personas.compact
  	end
  	personas.map{|p| ["#{p.user[:rut]} - #{p.user[:nombre_completo]}",p[:id]]}.sort
  end

  def self.ppp_base_vista
  	ProgramaProyectoPropuesta.where(resultado_postulacion: "postulacionaceptado").pluck('nombre_propuesta', 'id')
  end

  # DZC 2018-11-16 16:34:09 corrige error en obtención de instrumentos nulos
  def self.instrumentos_relacionados_collection(excepto=nil)
  	relacionados =  TipoInstrumento.por_padre_modelo
  	if excepto.present?
  		ppps = ProgramaProyectoPropuesta.where(resultado_postulacion: "postulacionaceptado").where.not(id: excepto).map{|x| 
  			["#{x.tipo_instrumento.nombre_tipo} : #{x.nombre_propuesta} ", "ProgramaProyectoPropuesta:#{x.id}"] if x.tipo_instrumento.present?
  		}.compact
  	else
  		ppps = ProgramaProyectoPropuesta.where(resultado_postulacion: "postulacionaceptado").map{|x| ["#{x.tipo_instrumento.nombre_tipo} : #{x.nombre_propuesta} ", "ProgramaProyectoPropuesta:#{x.id}"] if x.tipo_instrumento.present?
  	}.compac
  	end
  	instrumentos = ManifestacionDeInteres.where('diagnostico_fecha_termino IS NOT NULL').map{|x| ["#{x.tipo_instrumento.nombre_tipo} : #{x.nombre_proyecto}", "ManifestacionDeInteres:#{x.id}"] if x.tipo_instrumento.present?
  	}.compact + ppps + Proyecto.where.not(tipo_instrumento: nil).map{|x| ["#{x.tipo_instrumento.nombre_tipo} : #{x.nombre}", "Proyecto:#{x.id}"] if x.tipo_instrumento.present?
  	}.compact
  	relacionados.store('Instrumentos activos y/o finalizados', instrumentos)
  	relacionados
  end
  
end
