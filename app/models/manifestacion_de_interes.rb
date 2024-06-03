class ManifestacionDeInteres < ApplicationRecord

  # DZC 2019-03-01 11:36:03 tiempo para mostrar el mensaje de guardar
  MINUTOS_MENSAJE_GUARDAR = 20

  # DZC 2019-08-16 20:22:14 setea la cantidad de mensajes de error en archivo mapa de actores
  MAPA_DE_ACTORES_CANTIDAD_ERRORES = 5

  #belongs_to :representante, optional: true, foreign_key: :representante_institucion_para_solicitud_id, class_name: :User
  belongs_to :proponente_institucion, optional: true, foreign_key: :proponente_institucion_id, class_name: :Contribuyente
  #belongs_to :institucion_gestora, optional: true, foreign_key: :contribuyente_id, class_name: :Contribuyente
  has_many :documento_diagnosticos, foreign_key: :manifestacion_de_interes_id, dependent: :destroy
  accepts_nested_attributes_for :documento_diagnosticos, allow_destroy: true
  
  # DOSSA 2019-07-24 
  attr_accessor :estandar_certificable_cache, :descarga_estandar_seleccionado, :diagnostico_de_acuerdo_anterior_cache, :informe_de_acuerdo_anterior_cache,
                :descarga_formato_listado_de_actores, :listado_de_actores, :descarga_formato_cartas, :cartas_de_interes, :buscar_institución_gestora, :descarga_formato_carta_manifestacion_de_interes,
                :elegir_representante_institucion, :gantt_proyecto, :estudio_de_mercado, :anteproyecto, :otros_estudios, 
                :area_de_influencia, :alternativa_de_instalacion


  attr_accessor :current_tab, :temporal, :update_asignar_revisor, :update_admisibilidad, :update_admisibilidad_juridica, :update_obs_admisibilidad, :update_obs_admisibilidad_juridica,
  :update_pertinencia, :update_respuesta_pertinencia, :update_usuario_entregables, :current_user, :recuerde_guardar_reset_timer, :tarea_id #DZC 2019-07-11 17:42:46 se agrega :tarea_id para validaciones generalizadas

  # DOSSA 2019-09-24 16:26 atributo para radio button de estándares
  attr_accessor :radio_estandar, :radio_diagnostico, :radio_informe

  attr_accessor :actividad_economicas_ids, :comunas_ids, :cuencas_ids

  #titulos, como no se necesita registrar un texto del usuario solo lo usamos para mostrar
  attr_accessor :titulo_cifras_sectores_economicos, :titulo_caracterizacion_actividades_economicas

  attr_accessor :revisar_y_actualizar_mapa_de_actores
  attr_accessor :anulado

  attr_accessor :envia_termino_proceso
  attr_accessor :temp_siguientes

  belongs_to :tipo_instrumento, optional: true
  #belongs_to :contribuyente, optional: true
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
  serialize :secciones_observadas_admisibilidad_juridica
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
  # DOSSA 2019-09-30 14:39 se añade para ppp
  serialize :programas_o_proyectos_relacionados_ids

  enum resultado_admisibilidad: [:aceptado,:rechazado,:en_observación], _prefix: :resultado_admisibilidad
  enum resultado_admisibilidad_juridica: [:aceptado,:rechazado,:en_observación], _prefix: :resultado_admisibilidad_juridica
  enum resultado_pertinencia: [:aceptada,:solicita_condiciones,:realiza_observaciones,
                              :solicita_condiciones_y_contiene_observaciones,:no_aceptada], _prefix: :resultado_pertinencia
  enum respuesta_resultado_pertinencia: [:aceptada, :solicita_condiciones_o_información, :no_aceptada], _prefix: :respuesta_resultado_pertinencia

  attr_accessor :revisor_tecnico_id, :revisor_juridico_id,:coordinador_subtipo_instrumento_id, :encargado_hitos_prensa_id, :fondo_produccion_limpia, :tipo_linea_seleccionada
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
  mount_uploader :archivo_admisibilidad_juridica, ArchivoAdmisibilidadesManifestacionDeInteresUploader
  mount_uploader :archivo_pertinencia_factibilidad, ArchivoPertinenciasFactibilidadesManifestacionDeInteresUploader
  mount_uploader :archivo_respuesta_pertinencia_factibilidad, ArchivoRespuestasPertinenciasFactibilidadesManifestacionDeInteresUploader
  mount_uploader :archivo_usuario_entregables, ArchivoUsuariosEntregablesManifestacionDeInteresUploader 
  mount_uploaders :firma_archivo, ArchivoFirmasManifestacionDeInteresUploader
  mount_uploader :archivo_carga_auditoria, ArchivoCargaAuditoriasManifestacionDeInteresUploader

  mount_uploader :archivo_acta_comite_informe, ArchivoActaComiteManifestacionDeInteresUploader

  mount_uploader :texto_apl, ArchivoDocumentosGenericosManifestacionDeInteresUploader

  # DOSSA 2019-09-24 12:44 Archivos nuevos a subir al sistema
  mount_uploader :estandar_certificable, ArchivoEstandarCertificableUploader
  mount_uploader :diagnostico_de_acuerdo_anterior, ArchivoDiagnosticoDeAcuerdoAnteriorUploader
  mount_uploader :informe_de_acuerdo_anterior, ArchivoInformeDeAcuerdoAnteriorUploader

  before_validation :set_data_actecos
  before_validation :set_data_territorios

  #validates :sectores_economicos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :territorios_regiones, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :caracterizacion_sector_territorio, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :tipo_instrumento_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :proponente, presence: true, on: :update, unless: -> { temporal.to_s == "true" } 
  #validates :contribuyente_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :descripcion_acuerdo, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :carta_de_interes_institucion_gestora_firmada, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :proponente_institucion_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :caracterizacion_sector_territorio, presence: true, on: :update, unless: -> { temporal.to_s == "true" }numero_trabajadores
  #validates :principales_actores, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :mapa_de_actores_archivo, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  # DZC 2019-06-25 16:19:21 se agrega para manejar monto máximo a ingresar
  validates :numero_de_socios_institucion_gestora, numericality: {only_integer: true, less_than_or_equal_to: 2147483647}, on: :update, if: -> {self.numero_de_socios_institucion_gestora.present? && temporal.to_s != "true"} 

  # DZC 2019-06-25 16:26:07 se agrega para manejar monto máximo a ingresar
  validates :numero_empresas, presence: true, on: :update, if: -> { self.numero_empresas.present? && temporal.to_s != "true" }

  #validates :porcentaje_mipymes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  validates :produccion, presence: true, on: :update, if: -> { self.produccion.present? && temporal.to_s != "true" }

  # DZC 2019-06-25 16:20:54 se agrega para manejar monto máximo a ingresar
  validates :ventas, presence: true, on: :update, if: -> { self.ventas.present? && temporal.to_s != "true" }
  
  #validates :porcentaje_exportaciones, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  validates :principales_mercados, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  validates :cadena_de_valor, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

  # DZC 2019-06-25 16:20:35 se agrega para manejar monto máximo a ingresar
  validates :numero_trabajadores, presence: true, on: :update, if: -> { self.numero_trabajadores.present? && temporal.to_s != "true" }

  validates :vulnerabilidad_al_cambio_climatico_del_sector, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  validates :principales_impactos_socioambientales_del_sector, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  validates :principales_problemas_y_desafios, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  validates :principales_conflictos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #Validaciones datos del proyecto
  
  #validates :nombre_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :descripcion_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :justificacion_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  
  #ya no usaran archivos kml
  # validates :area_influencia_proyecto_archivo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  # validates :alternativas_instalacion_archivo, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :monto_inversion, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :tecnologia, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :estado_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  # validates :estudio_de_mercado, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  # validates :anteproyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  # validates :gantt_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  # validates :otros_estudios, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :operador, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :otros_proyectos_en_territorios_cercanos, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  #validates :otro_datos_proyecto, presence: true, on: :update, unless: -> { temporal.to_s == "true" || tipo_instrumento_id != 6}
  # validates :equipo_de_trabajo_comprometido, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :patrocinadores, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

  # DZC 2019-06-25 16:25:09 se agrega para manejar monto máximo a ingresar
  # DOSSA 2019-10-10 12:03 Se eliminan según documento "Campos finales: Manifestación de interés (Interno)"
  # validates :monto_total_comprometido, presence: true, numericality: {only_integer: true, less_than_or_equal_to: 2147483647}, on: :update, if: -> { self.monto_total_comprometido.present? || temporal.to_s != "true" }
  # validates :organigrama, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

  #validates :organigrama, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :otros_recursos_comprometidos, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  # validates :carta_de_apoyo_y_compromiso, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  
  # DOSSA 2019-10-10 12:02 Se eliminan según documento "Campos finales: Manifestación de interés (Interno)"
  # validates :numero_participantes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  # validates :lista_participantes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  # validates :priorizacion, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  
  #validates :diagnostico_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  #validates :estandar_de_certificacion_id, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  
  # DOSSA 2019-10-10 12:04 Se eliminan según documento "Campos finales: Manifestación de interés (Interno)"
  # validates :otros_estudios_relevantes, presence: true, on: :update, unless: -> { temporal.to_s == "true" }
  # validates :otros_objetivos_acuerdo, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

  validates :revisor_tecnico_id, presence: true, on: :update, if: -> {update_asignar_revisor.present?}
  validates :revisor_juridico_id, presence: true, on: :update, if: -> {update_asignar_revisor.present?}
  validates :comentario_jefe_de_linea, presence: true, on: :update, if: -> {update_asignar_revisor.present?}
  
  #validates :respuesta_resultado_pertinencia, presence: true, on: :update, if: -> { update_respuesta_pertinencia.present? } El campo ya no corresponde al apl-006

  validates :institucion_entregables_id, presence: true, on: :update, if: -> { update_usuario_entregables.present? }
  validates :institucion_entregables_name, presence: true, on: :update, if: -> { update_usuario_entregables.present? }
  validates :usuario_entregables_id, presence: true, on: :update, if: -> { update_usuario_entregables.present? }
  validates :usuario_entregable_name, presence: true, on: :update, if: -> { update_usuario_entregables.present? }
  #validates :usuario_entregables_comentario, presence: true, on: :update, if: -> { update_usuario_entregables.present? }

  validates :comentarios_y_observaciones_actualizacion_mapa_de_actores, presence: true, if: -> { temporal.to_s == "true" && mapa_de_actores_correctamente_construido.present? && mapa_de_actores_correctamente_construido == 'false' }
  validates :comentarios_y_observaciones_documento_diagnosticos, presence: true, if: -> { temporal.to_s == "true" && aprueba_documentos_diagnostico.present? && aprueba_documentos_diagnostico == 'false' }
  validates :comentarios_y_observaciones_set_metas_acciones, presence: true, if: -> { temporal.to_s == "true" && aprueba_set_metas_accion.present? && aprueba_set_metas_accion == 'false' }
  validates :observaciones_propuesta_acuerdo, presence: true, if: -> { temporal.to_s == "true" && envia_termino_proceso === true }

  validate :data_mapa_de_actores, on: :update, if: -> { self.mapa_de_actores_archivo.present? && self.revisar_y_actualizar_mapa_de_actores }

  #apl-003.1
  validates :resultado_admisibilidad, presence: true, on: :update, if: -> {update_admisibilidad.present? && temp_siguientes.to_s != "true"}
  validates :tipo_instrumento_id, presence: true, on: :update, if: -> {update_admisibilidad.present? && temp_siguientes.to_s != "true"}
  validates :observaciones_admisibilidad,presence: true, on: :update, if: -> {["rechazado","en_observación"].include?(resultado_admisibilidad) && temp_siguientes.to_s != "true"}
  validate :secciones_observadas_admisibilidad_requerido, on: :update, if: -> {["rechazado","en_observación"].include?(resultado_admisibilidad) && temp_siguientes.to_s != "true"}
  #apl-003.2
  validates :resultado_admisibilidad_juridica, presence: true, on: :update, if: -> {update_admisibilidad_juridica.present? && temp_siguientes.to_s != "true"}
  validates :observaciones_admisibilidad_juridica,presence: true, on: :update, if: -> {["rechazado","en_observación"].include?(resultado_admisibilidad_juridica) && temp_siguientes.to_s != "true"}
  validate :secciones_observadas_admisibilidad_juridica_requerido, on: :update, if: -> {["rechazado","en_observación"].include?(resultado_admisibilidad_juridica) && temp_siguientes.to_s != "true"}
  #apl-004.1
  validates :respuesta_observaciones_admisibilidad, presence: true, on: :update, if: -> {update_obs_admisibilidad == "true" && temp_siguientes.to_s != "true"}
  #apl-004.2
  validates :respuesta_observaciones_admisibilidad_juridica, presence: true, on: :update, if: -> {update_obs_admisibilidad_juridica == "true" && temp_siguientes.to_s != "true"}
  #apl-005
  validate :is_observaciones_pertinencia_factibilidad, on: :update, if: -> { update_pertinencia.present? && temp_siguientes.to_s != "true" }
  validate :is_compromiso_pertinencia_factibilidad, on: :update, if: -> { update_pertinencia.present? && temp_siguientes.to_s != "true" }
  validate :pertinencia_secciones_observadas, on: :update, if: -> { update_pertinencia.present? && temp_siguientes.to_s != "true" }
  validates :coordinador_subtipo_instrumento_id, presence: true, on: :update, if: -> { resultado_pertinencia == "aceptada" && update_pertinencia.present? && temp_siguientes.to_s != "true"}
  validates :encargado_hitos_prensa_id, presence: true, on: :update, if: -> { resultado_pertinencia == "aceptada" && update_pertinencia.present? && temp_siguientes.to_s != "true"}
  validates :resultado_pertinencia, presence: true, on: :update, if: -> { update_pertinencia.present? && temp_siguientes.to_s != "true" }
  validates :fondo_produccion_limpia, presence: true, on: :update, if: -> { resultado_pertinencia == "aceptada" && update_pertinencia.present? && temp_siguientes.to_s != "true"}
  validates :tipo_linea_seleccionada, presence: true, on: :update, if: -> { resultado_pertinencia == "aceptada" && update_pertinencia.present? && temp_siguientes.to_s != "true"}

  #apl-006
  validates :respuesta_observaciones_pertinencia_factibilidad, presence: true, on: :update, if: -> { update_respuesta_pertinencia == "true" && (resultado_pertinencia == "realiza_observaciones" || resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones") && temp_siguientes.to_s != "true"}
  validates :acepta_condiciones_pertinencia, inclusion: { in: [ true, false ] }, on: :update, if: -> { update_respuesta_pertinencia == "true" && (resultado_pertinencia == "solicita_condiciones" || resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones") && temp_siguientes.to_s != "true"}
  


  # DOSSA 2019-11-28 12:53 se añade ya que campo no se encuentra en mantenedor, sin embargo, es obligatorio
  #validates :unidad_de_medida_volumen, presence: true, on: :update, unless: -> { temporal.to_s == "true" }

  before_save :procesar_archivos_google_maps
  
  after_save :data_mapa_de_actores, if: -> { self.mapa_de_actores_archivo.present? && self.revisar_y_actualizar_mapa_de_actores }

  # DZC 2019-07-09 16:39:51 prueba de validación genérica de tamaños minimos y maximos contenido de campos
  validate :valida_largo_campos, on: :update, unless: -> { temporal.to_s == "true" }

  #validate :tree_selectors, on: :update, if: -> { temporal.to_s != "true"}

  #DZC se indisponibiliza por necesidad de pasar @tarea_codigo al método, para la realización de validaciones de actores indispensables
  # after_save :parsear_mapa_de_actores

  after_save :seleccion_de_radios

  after_save :log_deleted_file

  def log_deleted_file
    if !self.mapa_de_actores_archivo.file.nil? && !self.mapa_de_actores_archivo.file.exists?
      File.open(Rails.root.join('log','deleted_file.log'), 'a') {|f| f.write("\nID: #{self.id} - DT: #{DateTime.now.to_s}") }
    end
  end

  def secciones_observadas_admisibilidad_requerido
    errors.add(:secciones_observadas_admisibilidad, 'Debe seleccionar al menos uno') if self.secciones_observadas_admisibilidad.size == 1
  end
  def secciones_observadas_admisibilidad_juridica_requerido
    errors.add(:secciones_observadas_admisibilidad_juridica, 'Debe seleccionar al menos uno') if self.secciones_observadas_admisibilidad_juridica.size == 1
  end

  def representante
    return User.unscoped.find(self.representante_institucion_para_solicitud_id)
  end

  def institucion_gestora
    return Contribuyente.unscoped.find(self.contribuyente_id)
  end

  def contribuyente
    return Contribuyente.unscoped.find(self.contribuyente_id)
  end

  def proponente_institucion
    super || (Contribuyente.unscoped.find(self.proponente_institucion_id) if self.proponente_institucion_id.present?)
  end

  def estado_acuerdo
    tareas_ids = self.flujo.tarea_pendientes.pluck(:tarea_id)
    auditorias_34 = self.flujo.tarea_pendientes.where(tarea_id: Tarea::ID_APL_034).map{|tp| tp.data[:auditoria_id]}
    auditoria_final = Auditoria.where(id: auditorias_34, final: true).first
    estado_inicial = ""
    if !(Tarea::ETAPA_ACUERDO_MANIFESTACION_INTERES & tareas_ids).blank?
      estado_inicial = "Manifestación de interés"
    end
    if !(Tarea::ETAPA_ACUERDO_DIAGNOSTICO & tareas_ids).blank?
      estado_inicial = "Diagnóstico General"
    end
    if !(Tarea::ETAPA_ACUERDO_PROPUESTA_ACUERDO & tareas_ids).blank?
      estado_inicial = "Propuesta de Acuerdo"
    end
    if !(Tarea::ETAPA_ACUERDO_ADHESION & tareas_ids).blank?
      estado_inicial = "Adhesión"
    end
    if !(Tarea::ETAPA_ACUERDO_IMPLEMENTACION & tareas_ids).blank? && auditoria_final.nil?
      estado_inicial = "Implementación"
    end
    if !(Tarea::ETAPA_ACUERDO_EVALUACION_FINAL_CUMPLIMIENTO & tareas_ids).blank? && !auditoria_final.nil?
      estado_inicial = "Evaluación Final de Acuerdo"
    end
    estado_inicial
  end

  def tree_selectors
    #errors.add(:actividad_economicas_ids, "No puede estar en blanco") if actividad_economicas_ids.blank? || (!actividad_economicas_ids.blank? && actividad_economicas_ids.size <= 1)
    #errors.add(:comunas_ids, "No puede estar en blanco") if !acuerdo_de_alcance_nacional && (comunas_ids.blank? || (!comunas_ids.blank? && comunas_ids.size <= 1))
  end

  def seleccion_de_radios
    if self[:estandar_certificable].present? 
      self.radio_estandar = 0 
    elsif self[:estandar_de_certificacion_id].present? 
      self.radio_estandar = 1
    else
      self.radio_estandar = 3
    end

    if self[:diagnostico_de_acuerdo_anterior].present? 
      self.radio_diagnostico = 0 
    elsif self[:diagnostico_id].present? 
      self.radio_diagnostico = 1
    else
      self.radio_diagnostico = 3
    end

    if self[:informe_de_acuerdo_anterior].present? 
      self.radio_informe = 0 
    elsif self[:acuerdo_previo_con_informe_id].present? 
      self.radio_informe = 1
    else
      self.radio_informe = 3
    end
  end

  def procesar_archivos_google_maps
    # resultado = { area_influencia_proyecto_data: {}, alternativas_instalacion_data: {} }
    # unless self.area_influencia_proyecto_archivo.blank?
      
    # end

    # unless self.alternativas_instalacion_archivo.blank?
      
    # end
      
    # resultado

    #con cache significa que subio un archivo
    unless self.area_influencia_proyecto_archivo_cache.blank?
      self.area_influencia_proyecto_data = FileToPolygon.new(self.area_influencia_proyecto_archivo.path).map_data
    end
    unless self.alternativas_instalacion_archivo_cache.blank?
      self.alternativas_instalacion_data = FileToPolygon.new(self.alternativas_instalacion_archivo.path).map_data
    end
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
        :codigo_ciiuv4,
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
      ##
      # DZC 2019-08-16 20:26:20
      # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente      
      errores = []
      ruts_invalidos=[]
      emails_invalidos=[]
      telefonos_invalidos=[]
      dominios_invalidos=[]
      data.each_with_index do |fila, posicion|
        if fila.values.any?{|c|c.blank?}
          ##
          # DZC 2019-08-16 20:26:20
          # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente
          errores << "Fila #{(posicion+2)} contiene celdas sin completar"
          # errors.add(:mapa_de_actores_archivo, "El archivo contiene celdas sin completar")
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
        emails = data.map{|d| d[:email_institucional]} - ["no"]
        if emails.include?(fila[:email_institucional])
          temp = data.map{|d| [d[:rut_persona].to_s.gsub("k","K").gsub(".",""),d[:email_institucional]]}
          #obtengo todos los que hacen match con el email
          temp_filtro = temp.select{|t| t.last == fila[:email_institucional]}
          #Verifico aquellos que tenga el mismo rut
          temp_final = temp_filtro.select{|t| t.first == fila[:rut_persona].to_s.gsub("k","K").gsub(".","")}
          unless temp_filtro.size == temp_final.size
            ##
            # DZC 2019-08-16 20:26:20
            # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente
            errores << "Error en la línea #{(posicion+2)}. No se debe ingresar el mismo email a distintos usuarios"
            # errors.add(:mapa_de_actores_archivo, "Error en la línea #{(posicion+2)}. No se debe ingresar el mismo email a distintos usuarios")
            archivo_correcto = false
          end
        end
      end
      if ruts_invalidos.size > 0
        # DZC 2019-08-05 se modifica a requerimiento del cliente a fin de disminuir el tamaño del mensaje de error mostrado en tooltip
        ##
        # DZC 2019-08-16 20:26:20
        # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente
        errores << "El archivo contiene #{ruts_invalidos.size} RUTs inválidos. Los primeros cinco (o menos) RUT(s) con errores: '#{ruts_invalidos[0..4].to_sentence}', por favor corregir"
        # errors.add(:mapa_de_actores_archivo, "El archivo contiene #{ruts_invalidos.size} Los primeros cinco (o menos) RUT(s) con errores: '#{ruts_invalidos[0..4].to_sentence}', por favor corregir")
        archivo_correcto = false
      else
        # DZC 2018-10-30 16:17:15 determina los ruts de los actores que tienen tareas pendientes en el flujo
        ruts_con_tareas_pendientes = self.flujo.ruts_actores_con_tareas_pendientes


        # DZC 2018-10-30 16:17:35 determina el rut de los actores que se incluyen en el archivo
        ruts_en_archivo = data.map{|d| d[:rut_persona].to_s.gsub("k","K").gsub(".","")}

        # DZC 2018-10-30 16:17:55 determina el rut de los actores que no pueden eliminarse en el mapa de actores, y que subsistirán al poblamiento
        roles_no_eliminables = MapaDeActor.roles_no_actualizables(self.tarea_codigo)
        actores_no_eliminables_en_mapa = MapaDeActor.where(flujo_id: self.flujo, rol_id: roles_no_eliminables)
        personas_no_eliminables_en_mapa = Persona.where(id: actores_no_eliminables_en_mapa.pluck(:persona_id).uniq)
        usuarios_no_eliminables_en_mapa = User.where(id: personas_no_eliminables_en_mapa.pluck(:user_id).uniq)
        ruts_no_eliminables_en_mapa = usuarios_no_eliminables_en_mapa.pluck(:rut).uniq

        # DZC 2018-10-30 16:19:07 suma los ruts no eliminables a los que hay en el archivo, eliminando duplicados
        ruts_que_quedaran_en_mapa = (ruts_no_eliminables_en_mapa + ruts_en_archivo).uniq

        # DZC 2018-11-19 20:59:40 se corrige error en revisión de las tareas pendientes del revisor designado en APL-002
        unless ((ruts_con_tareas_pendientes & ruts_que_quedaran_en_mapa) == ruts_con_tareas_pendientes) || self.tarea_codigo == Tarea::COD_APL_001 || self.tarea_codigo == Tarea::COD_APL_002 || self.tarea_codigo == Tarea::COD_APL_003_1 || self.tarea_codigo == Tarea::COD_APL_003_2 || self.tarea_codigo == Tarea::COD_APL_004_1 || self.tarea_codigo == Tarea::COD_APL_004_2 || self.tarea_codigo == Tarea::COD_APL_005 || self.tarea_codigo == Tarea::COD_APL_006 || self.tarea_codigo == Tarea::COD_APL_008

          ruts_eliminados = ruts_con_tareas_pendientes - (ruts_con_tareas_pendientes & ruts_que_quedaran_en_mapa)
          ##
          # DZC 2019-08-16 20:26:20
          # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente
          errores << "No es posible procesar el archivo, pues no contiene al o los usuarios: #{User.nombre_por_rut(ruts_eliminados)} ; que mantiene(n) tarea(s) pendiente(s) sin terminar. Por favor corregir."
          # errors.add(:mapa_de_actores_archivo, "No es posible procesar el archivo, pues no contiene al o los usuarios: #{User.nombre_por_rut(ruts_eliminados)} ; que mantiene(n) tarea(s) pendiente(s) sin terminar. Por favor corregir.")
          archivo_correcto = false
        end
      end
      
      if emails_invalidos.size > 0
        # DZC 2019-08-05 se modifica a requerimiento del cliente a fin de disminuir el tamaño del mensaje de error mostrado en tooltip
        ##
        # DZC 2019-08-16 20:26:20
        # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente
        errores << "El archivo contiene #{emails_invalidos.size} emails inválidos. Los primeros cinco (o menos) Email(s) con errores: '#{emails_invalidos[0..4].to_sentence}', por favor corregir"
        # errors.add(:mapa_de_actores_archivo, "El archivo contiene #{emails_invalidos.size} Los primeros cinco (o menos) Email(s) con errores: '#{emails_invalidos[0..4].to_sentence}', por favor corregir")
        archivo_correcto = false
      else

        # DZC 2018-10-26 15:20:58 se reemplaza validación de eMail repetidos por validación eMail + RUT implementada por Ricardo 
        # emails = data.map{|d|d[:email_institucional]}
        # repetidos = emails.uniq.size - emails.size
        # if repetidos != 0
        #   errors.add(:mapa_de_actores_archivo, "El archivo contiene #{repetidos.abs} Emails repetidos, por favor indicar un correo distinto por cada actor")
        #   archivo_correcto = false
        # end
      end

      if telefonos_invalidos.size > 0
        # DZC 2019-08-05 se modifica a requerimiento del cliente a fin de disminuir el tamaño del mensaje de error mostrado en tooltip
        ##
        # DZC 2019-08-16 20:26:20
        # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente
        errores << "El archivo contiene #{telefonos_invalidos.size} teléfonos inválidos. Los primeros cinco (o menos) Teléfono(s) con errores: '#{telefonos_invalidos[0..4].to_sentence}'; Por favor corregir"
        #errors.add(:mapa_de_actores_archivo, "El archivo contiene #{telefonos_invalidos.size} Los primeros cinco (o menos) Teléfono(s) con errores: '#{telefonos_invalidos[0..4].to_sentence}'; Por favor corregir")
        archivo_correcto = false
      end
      
      if archivo_correcto
        unless roles_minimos.blank? #DZC revisa que se cumpla con los roles minimos
          roles_correctos = true
          roles_minimos.each {|k, v|
            # DZC 2018-11-02 12:49:22 se corrige error en comparación de cantidad de roles mínimos
            #roles_correctos = (data.select{|d| d[:rol_en_acuerdo]==k.to_s}.count < v) ? false : roles_correctos
            #si rol existe, comprobar que no sea la misma persona (llave rut persona - rut institucion)
            personas_unicas = []
            filas_con_rol_requerido = data.select{|d| d[:rol_en_acuerdo]==k.to_s}
            filas_con_rol_requerido.each do |persona|
              personas_unicas << persona[:rut_persona].to_s.gsub("k","K").gsub(".","")+"/"+persona[:rut_institucion].to_s.gsub("k","K").gsub(".","") if !personas_unicas.include?(persona[:rut_persona].to_s.gsub("k","K").gsub(".","")+"/"+persona[:rut_institucion].to_s.gsub("k","K").gsub(".",""))
            end

            roles_correctos = (personas_unicas.count < v) ? false : roles_correctos
          } 
          if !roles_correctos 
            ##
            # DZC 2019-08-16 20:26:20
            # para el ajuste de la cantidad de errores de acuerdo a lo solicitado por el cliente
            errores << "El archivo no contiene la cantidad mínima de actores con roles específicos exigidos para esta tarea"
            # errors.add(:mapa_de_actores_archivo, "El archivo no contiene la cantidad mínima de actores con roles específicos exigidos para esta tarea")
            archivo_correcto = false
          end
        end
      end

      if archivo_correcto #DZC se mantiene el almacenamiento de data en el campo mapa_actores_data, para mantener la comparación de archivo 

        # self.mapa_de_actores_data = data
        self.mapa_de_actores_data = MapaDeActor.adecua_actores_para_vista(data)
        return true
      else
        ##
        # DZC 2019-08-16 20:26:20
        # se ajusta la cantidad de errores de acuerdo a lo solicitado por el cliente
        cinco_errores = ""
        errores[0..(ManifestacionDeInteres::MAPA_DE_ACTORES_CANTIDAD_ERRORES-1)].each do |e|
          cinco_errores += e +". <br/>" 
        end
        errors.add(:mapa_de_actores_archivo, cinco_errores)
        #self.mapa_de_actores_data = nil
        #self.mapa_de_actores_archivo.remove!
        #self.mapa_de_actores_archivo = nil
        
        return false
      end   
    end
  end

  def dominios_mapa_de_actores_validos?(fila)
    dominios = MapaDeActor.dominios

    roles_invalidos = []
    cargos_invalidos  = []
    sectores_invalidos  = []
    tipo_instituciones_invalidos  = []
    comunas_invalidas = []

    valores = {
      rol_en_acuerdo: :roles,
      cargo_en_institucion: :cargos,
      codigo_ciiuv4: :sectores,
      tipo_de_institucion: :tipo_instituciones,
      comuna_institucion: :comunas
    }

    header = [
        :rol_en_acuerdo,
        :rut_persona,
        :nombre_completo_persona,
        :cargo_en_institucion,
        :rut_institucion,
        :codigo_ciiuv4,
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
        elsif campo == :codigo_ciiuv4
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

    if fila[:rut_persona].to_s != "no" && !fila[:rut_persona].to_s.rut_valid?
      validaciones[:ruts_invalidos] = fila[:ruts_invalidos]
    end

    if fila[:email_institucional].to_s != "no" && !fila[:email_institucional].to_s.email_valid?
      validaciones[:emails_invalidos] = fila[:email_institucional]
    end

    ## 
    # DZC 2018-10-20 21:05:30 se agrega la validación para el caso de que el rut y/o el eMail prexistan 
    # en la tabla de usuarios, en registros distintos
    if validaciones[:ruts_invalidos].nil? && validaciones[:emails_invalidos].nil? && fila[:email_institucional].to_s != "no" && fila[:rut_persona].to_s != "no"
      ##
      # DZC 2019-08-08 13:17:17 se modifica para solo se considera el hecho de que el un usuario con rut 
      # distinto tenga el mismo email, pues los demás casos son irrelevantes.
      #user = User.find_by(rut: fila[:rut_persona].to_s.gsub("k","K").gsub(".","")) 
      email = User.find_by(email: fila[:email_institucional].to_s)
      if email.present? && email.rut.to_s.gsub("k","K").gsub(".","") != fila[:rut_persona].to_s.gsub("k","K").gsub(".","")
        validaciones[:emails_invalidos] = "El eMail #{fila[:email_institucional]} ya existe en la base de datos de usuarios y dicho usuario tiene asociado otro RUT."
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

  def actividades_economicas
    self.flujo.actividad_economicas
  end

  def actividades_economicas_beauty_tree_selector
    ActividadEconomica.beauty_tree_selector_v2(self.actividades_economicas.pluck(:id))
  end

  def comunas_beauty_tree_selector
    Pais.find(Pais::CHILE).beauty_tree_selector(self.comunas.pluck(:id))
  end

  def cuencas_beauty_tree_selector
    Cuenca.beauty_tree_selector_v2(self.cuencas.pluck(:id))
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
      "objetivo-acuerdo": [
        :nombre_acuerdo,
        :motivacion_y_objetivos,
        :relacion_de_politicas,
        :otras_iniciativas_relacionadas_en_ejecucion,
        :programas_o_proyectos_relacionados_ids,
        :fuente_de_fondos,
        :justificacion_de_estimacion_de_fondos_requeridos,
        :nombre_de_estandar_certificable, 
        :estandar_certificable,
        :estandar_de_certificacion_id,
        :diagnostico_de_acuerdo_propuesto,
        :diagnostico_de_acuerdo_anterior,
        :diagnostico_id,
        :informe_de_acuerdo_anterior,
        :acuerdo_previo_con_informe_id,
      ],
      "datos-institucion": [
        :proponente,
        :proponente_institucion_id,
        :institucion_gestora_acuerdo,
        :rut_institucion_gestora_acuerdo,
        :fecha_creacion_institucion,
        :direccion_institucion_gestora_acuerdo,
        :ubicacion_exacta,
        :numero_de_socios_institucion_gestora,
        :tipo_contribuyente_de_institucion_gestora,
        :sucursal_ligada,
        :justificacion_de_seleccion,
        :registro_en_linea,
        :equipo_de_trabajo_comprometido,
        :experiencia_en_gestion_de_proyectos,
        :nombre_representante_para_acuerdo,
        :rut_representante_para_acuerdo,
        :email_representante_para_acuerdo,
        :telefono_representante_para_acuerdo,
        :carta_de_interes_institucion_gestora_firmada,
      ],
      "contexto-sector": [
        :actividad_economicas_ids,
        :numero_empresas,
        :produccion,
        :unidad_de_medida_volumen,
        :ventas,
        :porcentaje_exportaciones,
        :numero_trabajadores,
        :comentarios_cifras,
        :principales_mercados,
        :cadena_de_valor,
        :otras_caracteristicas_relevantes,
        :acuerdo_de_alcance_nacional,
        :comunas_ids,
        :cuencas_ids,
        :caracterizacion_sector_territorio,
        :vulnerabilidad_al_cambio_climatico_del_sector,
        :principales_impactos_socioambientales_del_sector,
        :principales_problemas_y_desafios,
        :principales_conflictos,
        :otro_contexto_sector,
        :estudios_sectoriales_territoriales_relevantes
      ],
      "datos-proyecto": [
        :nombre_proyecto,
        :descripcion_proyecto,
        :justificacion_proyecto,
        :detalle_de_localizacion,
        :detalle_de_alternativa_de_instalacion,
        :area_influencia_proyecto_archivo,
        :alternativas_instalacion_archivo,
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
      "admisibilidad": [
        :respuesta_observaciones_admisibilidad,
      ],
      "pertinencia-factibilidad": [
        # :respuesta_observaciones_admisibilidad,
        :respuesta_observaciones_pertinencia_factibilidad,
      ],
      "actores-y-partes-interesadas": [
        :principales_actores,
        :otros_recursos_comprometidos,
        :mapa_de_actores_archivo,
        :carta_de_apoyo_y_compromiso,
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
    Responsable.__personas_responsables(Rol::REVISOR_TECNICO, tipo_instrumento_id).map{|p| [p.user.nombre_completo, p.id]}     
  end

  def usuarios_entregables_select
    # DZC 2018-10-03 17:41:49 se corrige la búsqueda de responsables según el tipo de instrumento de la instancia
    tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id   
    Responsable.__personas_responsables(Rol::RESPONSABLE_ENTREGABLES, tipo_instrumento_id).map{|p| [p.user.nombre_completo, p.id]}
  end

  def is_observaciones_pertinencia_factibilidad
    if  (self.resultado_pertinencia == "realiza_observaciones" || self.resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones" || self.resultado_pertinencia == "no_aceptada") && self.observaciones_pertinencia_factibilidad.blank?
      errors.add(:observaciones_pertinencia_factibilidad, "Resultado de pertinencia requiere una observación")
    end
  end

  def is_compromiso_pertinencia_factibilidad
    if  (self.resultado_pertinencia == "solicita_condiciones" || self.resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones" || self.resultado_pertinencia == "no_aceptada") && self.compromiso_pertinencia_factibilidad.blank?
      errors.add(:compromiso_pertinencia_factibilidad, "Resultado de pertinencia requiere compromiso")
    end
  end

  def pertinencia_secciones_observadas
    if !self.resultado_pertinencia.blank? && self.resultado_pertinencia != "aceptada" && secciones_observadas_pertinencia_factibilidad.length == 1
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
    _firma_fecha = firma_fecha_hora.blank? ? firma_fecha : firma_fecha_hora
    _firma_fecha.blank? ? nil : (I18n.localize _firma_fecha, format: :long)
    # I18n.localize firma_fecha, format: :long
  end

  def completar_informacion!
    #Completa la información de la institución cogestora cuando está cambia
    completar_institucion_cogestora
    self.representante_institucion_para_solicitud_id = nil if self.contribuyente_id_changed?
    if self.proponente_institucion_id_changed?
      #Diria que ya no va
      #verificar_es_cogestora
      self.representante_institucion_para_solicitud_id = nil
    end
    completar_representate_institucion    
  end
  def completar_institucion_cogestora
    if self.contribuyente_id.present?
      contribuyente = Contribuyente.unscoped.find(self.contribuyente_id)
      self.flujo.update(contribuyente_id: contribuyente.id)
      persona_de_contribuyente = self.current_user.personas.where(contribuyente_id: contribuyente.id).first
      self.institucion_gestora_acuerdo = contribuyente.razon_social
      self.rut_institucion_gestora_acuerdo = contribuyente.rut_completo
      self.tipo_contribuyente_de_institucion_gestora = contribuyente.tipo_contribuyente
      
      casa_matriz = contribuyente.direccion_casa_matriz(false,true)
      self.direccion_institucion_gestora_acuerdo = "#{casa_matriz[:direccion]} #{casa_matriz[:comuna]} #{casa_matriz[:region]} #{casa_matriz[:pais]}"
      self.lugar_institucion_gestora_acuerdo = casa_matriz[:comuna]
      if casa_matriz.is_a?(Hash) && ! casa_matriz[:comuna].blank?
        coordinates = GeoLocalization.get_coordinates(casa_matriz[:direccion],"#{casa_matriz[:comuna]} #{casa_matriz[:region]}",casa_matriz[:pais])
        self.ubicacion_exacta = "#{coordinates.map{|k,v|v}.join(",")}"
        self.sucursal_ligada = casa_matriz[:id]
      end
      self.fecha_creacion_institucion = Date.today if !self.fecha_creacion_institucion.blank? && self.fecha_creacion_institucion > Date.today
    else
      self.flujo.update(contribuyente_id: nil)
      self.institucion_gestora_acuerdo = nil
      self.rut_institucion_gestora_acuerdo = nil
      self.tipo_contribuyente_de_institucion_gestora = nil
      self.direccion_institucion_gestora_acuerdo = nil
      self.lugar_institucion_gestora_acuerdo = nil
      self.ubicacion_exacta = nil
      self.sucursal_ligada = nil
      self.fecha_creacion_institucion = nil
    end
  end
  def completar_representate_institucion
    if self.representante_institucion_para_solicitud_id.present?
      representante = User.unscoped.find(self.representante_institucion_para_solicitud_id)
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
        #Estos datos no deberian cambiar porque son los de la institucion gestora
        #self.contribuyente_id  = self.proponente_institucion_id
        #self.flujo.update(contribuyente_id: self.contribuyente_id)
        completar_institucion_cogestora
      else
        self.contribuyente_id = nil
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

  def comentarios_mapa_de_actores_ordenados
    self.comentarios_y_observaciones_actualizacion_mapa_de_actores.present? ? 
      self.comentarios_y_observaciones_actualizacion_mapa_de_actores.sort_by{|c| c[:datetime]}.reverse : []
  end

  def comentarios_set_metas_acciones_ordenados
    self.comentarios_y_observaciones_set_metas_acciones.present? ? 
      self.comentarios_y_observaciones_set_metas_acciones.sort_by{|c| c[:datetime]}.reverse : []
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


  def self.informe_de_impactos_selector
    InformeImpacto.all.map{|a| [a.manifestacion_de_interes.nombre_acuerdo, a.id]}
  end

  def self.ppp_aprobados
    flujo_ids = TareaPendiente.where(tarea_id: [26,28]).pluck(:flujo_id).uniq
    ppp_id = Flujo.find(flujo_ids).pluck(:programa_proyecto_propuesta_id).uniq
    ProgramaProyectoPropuesta.find(ppp_id).map{|f| [f.nombre_propuesta, f.id]}
  end

  def programas_o_proyectos_relacionados
    ProgramaProyectoPropuesta.where(id: programas_o_proyectos_relacionados_ids)
  end

  def comunas
    self.flujo.comunas
  end

  def cuencas
    self.flujo.cuencas
  end

  def confirmar_temporales_a_definitivos
    #Metodo devuelve el registro final (sea nuevo o editado)
    contribuyente_temporal = Contribuyente.unscoped.find(self.contribuyente_id)
    contribuyente_final = contribuyente_temporal.confirmar_temporal
    self.contribuyente_id = contribuyente_final.id
    self.flujo.update(contribuyente_id: self.contribuyente_id)
    self.sucursal_ligada = EstablecimientoContribuyente.unscoped.find(self.sucursal_ligada).establecimiento_contribuyente_id
    #Elimino el temporal si es editado
    contribuyente_temporal.destroy if !contribuyente_temporal.contribuyente_id.nil?

    #Metodo devuelve el registro final (sea nuevo o editado)
    usuario_temporal = User.unscoped.find(self.representante_institucion_para_solicitud_id)
    usuario_final = usuario_temporal.confirmar_temporal
    self.representante_institucion_para_solicitud_id = usuario_final.id
    #Elimino el temporal si es editado
    usuario_temporal.destroy if !usuario_temporal.user_id.nil?

    #recargo la data de manifestacion de interes
    self.completar_institucion_cogestora
    self.completar_representate_institucion
    #Guardamos
    self.save
  end

  def self.unidades_de_medida_para_volumen
    [['ton','toneladas'], ['kg', 'kilogramos']]
  end

  def generar_pdf mapa_territorio, mapa_area_influencia, mapa_alternativas
    require 'stringio'

    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")
    ##HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width do
        #pdf.image Rails.root.join('app','assets','images','logo-ascc.png').to_s, width: 150
        pdf.image Rails.root.join("app/assets/images/logo-ascc.png"), width: 119
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom], :width  => pdf.bounds.width do
          pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do 
            pdf.text "FORMULARIO DE MANIFESTACIÓN DE INTERÉS", size: 10, color: "003DA6", align: :right
          end
        end
        pdf.move_down 8
        pdf.stroke do
          pdf.stroke_color '003DA6'
          pdf.line_width 3
          pdf.stroke_horizontal_rule
        end
      end
    end

    ##CONTENIDO
    validaciones = self.get_campos_validaciones

    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 100], :width  => pdf.bounds.width do
      #PESTAÑA 1
      self.pdf_titulo_formato(pdf, I18n.t(:objetivo_acuerdo), "Motivación y fundamentos del acuerdo")
      self.pdf_contenido_formato(pdf, :nombre_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :motivacion_y_objetivos, validaciones)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, :relacion_de_politicas, validaciones)
      self.pdf_contenido_formato(pdf, :otras_iniciativas_relacionadas_en_ejecucion, validaciones)
      self.pdf_contenido_formato(pdf, :programas_o_proyectos_relacionados_ids, validaciones)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, :fuente_de_fondos, validaciones)
      self.pdf_contenido_formato(pdf, :justificacion_de_estimacion_de_fondos_requeridos, validaciones)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, :nombre_de_estandar_certificable, validaciones)
      self.pdf_contenido_formato(pdf, :estandar_certificable, validaciones)
      self.pdf_contenido_formato_select(
        pdf, 
        :estandar_de_certificacion_id, 
        (self.estandar_homologacion.nil? ? '' : self.estandar_homologacion.nombre), 
        Rails.application.routes.url_helpers.descarga_estandar_o_acuerdo_documento_diagnosticos_manifestacion_de_interes_path(0, self,estandar_id: self.estandar_de_certificacion_id), 
        validaciones
      )
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, :diagnostico_de_acuerdo_propuesto, validaciones)
      self.pdf_contenido_formato(pdf, :diagnostico_de_acuerdo_anterior, validaciones)
      self.pdf_contenido_formato_select(
        pdf, 
        :diagnostico_id, 
        (self.antiguo.nil? ? '' : self.antiguo.nombre_acuerdo), 
        Rails.application.routes.url_helpers.descarga_estandar_o_acuerdo_documento_diagnosticos_manifestacion_de_interes_path(0, self,diagnostico_id: self.diagnostico_id), 
        validaciones
      )
      self.pdf_contenido_formato(pdf, :informe_de_acuerdo_anterior, validaciones)
      self.pdf_contenido_formato(pdf, :acuerdo_previo_con_informe_id, validaciones)
      self.pdf_separador(pdf, 20)

      #PESTAÑA 2
      self.pdf_titulo_formato(pdf, I18n.t(:contexto_sector), "Contexto Sector y/o Territorio Involucrado")
      self.pdf_contenido_formato_checks(pdf, :actividad_economicas_ids, self.actividades_economicas_beauty_tree_selector, validaciones)
      self.pdf_contenido_formato(pdf, :numero_empresas, validaciones)
      self.pdf_contenido_formato(pdf, :produccion, validaciones)
      self.pdf_contenido_formato(pdf, :unidad_de_medida_volumen, validaciones)
      self.pdf_contenido_formato_custom(pdf, :ventas, ActionController::Base.helpers.number_to_currency(self.ventas), validaciones)
      self.pdf_contenido_formato_custom(pdf, :porcentaje_exportaciones, self.porcentaje_exportaciones, validaciones)
      self.pdf_contenido_formato(pdf, :numero_trabajadores, validaciones)
      self.pdf_contenido_formato(pdf, :comentarios_cifras, validaciones)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, :principales_mercados, validaciones)
      self.pdf_contenido_formato(pdf, :cadena_de_valor, validaciones)
      self.pdf_contenido_formato(pdf, :otras_caracteristicas_relevantes, validaciones)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato_custom(pdf, :acuerdo_de_alcance_nacional, (self.acuerdo_de_alcance_nacional ? "Si" : "No"), validaciones, true)
      self.pdf_contenido_formato_checks(pdf, :comunas_ids, self.comunas_beauty_tree_selector, validaciones)
      pdf.image StringIO.new(Base64.decode64(splitBase64(mapa_territorio)[:data])), fit: [pdf.bounds.width, 400]
      pdf.move_down 11
      self.pdf_contenido_formato_checks(pdf, :cuencas_ids, self.cuencas_beauty_tree_selector, validaciones)
      self.pdf_contenido_formato(pdf, :caracterizacion_sector_territorio, validaciones)
      self.pdf_contenido_formato(pdf, :vulnerabilidad_al_cambio_climatico_del_sector, validaciones)
      self.pdf_contenido_formato(pdf, :principales_impactos_socioambientales_del_sector, validaciones)
      self.pdf_contenido_formato(pdf, :principales_problemas_y_desafios, validaciones)
      self.pdf_contenido_formato(pdf, :principales_conflictos, validaciones)
      self.pdf_contenido_formato(pdf, :otro_contexto_sector, validaciones)
      self.pdf_contenido_formato(pdf, :estudios_sectoriales_territoriales_relevantes, validaciones)
      self.pdf_separador(pdf, 20)

      #PESTAÑA 3
      self.pdf_titulo_formato(pdf, I18n.t(:actores_y_partes_interesadas), "Identificación de actores relevantes para el Acuerdo, así como recursos que estos podrían comprometer")
      self.pdf_contenido_formato(pdf, :principales_actores, validaciones)
      self.pdf_contenido_formato(pdf, :mapa_de_actores_archivo, validaciones)
      self.pdf_contenido_formato(pdf, :otros_recursos_comprometidos, validaciones)
      self.pdf_contenido_formato(pdf, :carta_de_apoyo_y_compromiso, validaciones)
      self.pdf_separador(pdf, 20)

      #PESTAÑA 4
      self.pdf_titulo_formato(pdf, I18n.t(:datos_institucion), "Datos Institución Gestora Acuerdo que actuará como contraparte de los organismos públicos firmantes")
      self.pdf_contenido_formato(pdf, :proponente, validaciones)
      self.pdf_contenido_formato_custom(pdf, :proponente_institucion_id, (self.proponente_institucion.blank? || self.proponente_institucion.razon_social.blank? ? "Sin razón social." : self.proponente_institucion.razon_social), validaciones, true)
      self.pdf_contenido_formato(pdf, :institucion_gestora_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :rut_institucion_gestora_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :fecha_creacion_institucion, validaciones)
      self.pdf_contenido_formato(pdf, :numero_de_socios_institucion_gestora, validaciones)
      self.pdf_contenido_formato(pdf, :direccion_institucion_gestora_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :ubicacion_exacta, validaciones)
      self.pdf_contenido_formato(pdf, :tipo_contribuyente_de_institucion_gestora, validaciones)
      establecimiento_contribuyente = EstablecimientoContribuyente.unscoped.where(id: self.sucursal_ligada).first
      self.pdf_contenido_formato_custom(pdf, :sucursal_ligada, (establecimiento_contribuyente.nil? ? '' : establecimiento_contribuyente.nombre_and_direccion), validaciones)
      self.pdf_contenido_formato(pdf, :justificacion_de_seleccion, validaciones)
      self.pdf_contenido_formato(pdf, :registro_en_linea, validaciones)
      self.pdf_contenido_formato(pdf, :equipo_de_trabajo_comprometido, validaciones)
      self.pdf_contenido_formato(pdf, :experiencia_en_gestion_de_proyectos, validaciones)
      self.pdf_contenido_formato(pdf, :nombre_representante_para_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :rut_representante_para_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :email_representante_para_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :telefono_representante_para_acuerdo, validaciones)
      self.pdf_contenido_formato(pdf, :carta_de_interes_institucion_gestora_firmada, validaciones)
      self.pdf_separador(pdf, 20)

      #PESTAÑA 5
      self.pdf_titulo_formato(pdf, I18n.t(:datos_proyecto), "Solo Aplica a Acuerdos que tienen por objetivo la instalación de proyectos de inversión socio ambientalmente sólidos y confiables")
      self.pdf_contenido_formato(pdf, :nombre_proyecto, validaciones)
      self.pdf_contenido_formato(pdf, :descripcion_proyecto, validaciones)
      self.pdf_contenido_formato(pdf, :justificacion_proyecto, validaciones)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, :detalle_de_localizacion, validaciones)
      self.pdf_contenido_formato(pdf, :detalle_de_alternativa_de_instalacion, validaciones)
      pdf.image StringIO.new(Base64.decode64(splitBase64(mapa_area_influencia)[:data])), fit: [pdf.bounds.width, 400]
      pdf.move_down 11
      self.pdf_contenido_formato(pdf, :area_influencia_proyecto_archivo, validaciones)
      pdf.image StringIO.new(Base64.decode64(splitBase64(mapa_alternativas)[:data])), fit: [pdf.bounds.width, 400]
      pdf.move_down 11
      self.pdf_contenido_formato(pdf, :alternativas_instalacion_archivo, validaciones)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, :estado_proyecto, validaciones)
      self.pdf_contenido_formato(pdf, :tecnologia, validaciones)
      self.pdf_contenido_formato(pdf, :operador, validaciones)
      self.pdf_contenido_formato_custom(pdf, :monto_inversion, ActionController::Base.helpers.number_to_currency(self.monto_inversion), validaciones)
      self.pdf_contenido_formato(pdf, :otros_proyectos_en_territorios_cercanos, validaciones)
      self.pdf_contenido_formato(pdf, :otro_datos_proyecto, validaciones)
      self.pdf_contenido_formato(pdf, :gantt_proyecto, validaciones)
      self.pdf_contenido_formato(pdf, :estudio_de_mercado, validaciones)
      self.pdf_contenido_formato(pdf, :anteproyecto, validaciones)
      self.pdf_contenido_formato(pdf, :otros_estudios, validaciones)

    end

    pdf
  end

  def pdf_titulo_formato pdf, titulo, subtitulo
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do 
      pdf.text titulo, size: 11
    end
    pdf.text subtitulo, size: 9
    pdf.text "··········<color rgb='003DA6'>··········</color>", size: 20, color: 'EB0029', inline_format: true, leading: 0
    pdf.move_down 15
  end

  def pdf_contenido_formato pdf, variable, validaciones
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      valor = self.send(variable.to_s)
      if valor.blank?
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      elsif valor.class.superclass == CarrierWave::Uploader::Base
        #pdf.text "<link href='"+valor.url+"'>"+valor.file.filename+"</link>", size: 9, color: '007BFF', inline_format: true
        self.pdf_boton_descarga(pdf, valor.url, valor.file.filename)
      elsif([String,Integer].include?(valor.class))
        pdf.text valor.to_s, size: 9, color: '555555', align: :justify
      elsif(valor.class == Symbol)
        pdf.text I18n.t(valor.to_s.gsub!('-', '_')), size: 9, color: '555555', align: :justify
      end
      pdf.move_down 11
    end
  end

  def pdf_contenido_formato_custom pdf, variable, valor, validaciones, forzar_mostrar=false
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      valor_por_variable = self.send(variable.to_s)
      if((valor_por_variable.blank? || valor.blank?) && !forzar_mostrar)
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      else
        pdf.text valor, size: 9, color: '555555', align: :justify
      end
      pdf.move_down 11
    end
  end

  def pdf_contenido_formato_select pdf, variable, valor_real, link, validaciones
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      valor = self.send(variable.to_s)
      if valor.blank?
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      else
        if link.blank?
          pdf.text valor_real, size: 9, color: '555555', align: :justify
        else
          #pdf.text "<link href='"+link+"'>"+valor_real+"</link>", size: 9, color: '007BFF', inline_format: true
          self.pdf_boton_descarga(pdf, link, valor_real)
        end
      end
      pdf.move_down 11
    end
  end

  def pdf_contenido_formato_checks pdf, variable, valores, validaciones
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      if valores.blank? || valores.select{|v| v[:status] == "indeterminate" || v[:status] == "checked" }.size == 0
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      else
        self._pdf_contenido_format_checks(pdf, valores)
      end
      pdf.move_down 11
    end
  end

  def _pdf_contenido_format_checks pdf, valores
    valores.each do |valor|
      if valor[:status] == 'indeterminate'
        self._pdf_contenido_format_checks(pdf, valor[:children])
      elsif valor[:status] == 'checked'
        pdf.text valor[:name], size: 9, color: '555555'
        pdf.move_down 5
        pdf.stroke do
          pdf.stroke_color '555555'
          pdf.line_width 1
          pdf.stroke_horizontal_rule
        end
        pdf.move_down 5
      end
    end
  end

  def pdf_boton_descarga pdf, link, texto
    pdf.table([
      [
        {
          image: Rails.root.join("app/assets/images/download-solid-blue.jpg").to_s,
          image_height: 9,
          image_width: 9
        },
        "<font size='9'><color rgb='007BFF'><link href='"+link+"'>"+texto+"</link></color></font>"
      ]
    ],
    cell_style: {
      border_color: "007BFF",
      inline_format: true
    }) do
      cells.borders = []
      column(0).borders =[:bottom, :left, :top]
      column(0).padding =[5, 2, 5, 5]
      column(1).borders =[:bottom, :right, :top]
      column(1).padding =[5, 5, 5, 2]
    end
  end

  def pdf_separador(pdf, tamano_pos)
    pdf.stroke do
      pdf.stroke_color 'E5E5E5'
      pdf.line_width 1
      pdf.stroke_horizontal_rule
    end
    pdf.move_down tamano_pos

  end

  def splitBase64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type:      $1, # "image/png"
        encoder:   $2, # "base64"
        data:      $3, # data string
        extension: $1.split('/')[1] # "png"
        }
    end
  end

  def estado_consulta_publica
    flujo_id = self.flujo.id
    tarea_19 = TareaPendiente.where(flujo_id: flujo_id, tarea_id: Tarea::ID_APL_019).first
    tarea_20 = TareaPendiente.where(flujo_id: flujo_id, tarea_id: Tarea::ID_APL_020).first
    estado_consulta = "No iniciada"
    if !tarea_19.nil?
      estado_consulta = "Abierta"
      if !tarea_20.nil? && tarea_19.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA
        estado_consulta = "Cerrada" if tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::NO_INICIADA
        estado_consulta = "Finalizada" if tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA
      end
    end
    estado_consulta
  end

  def empresas_adheridas
    _ruts = []
    elementos_adheridos.each do |elem|
      _ruts << elem[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first
    end
    Contribuyente.where(rut: _ruts)
  end

  def empresas_certificadas
    _ruts = []
    elementos_certificados.each do |elem|
      _ruts << elem[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first
    end
    Contribuyente.where(rut: _ruts)
  end

  def acciones
    SetMetasAccion.where(flujo_id: self.flujo.id)
  end

  def elementos_adheridos
    elementos_adheridos = []
    adhesiones_ids = Adhesion.unscoped.where(flujo_id: self.flujo.id).pluck(:id)
    AdhesionElemento.where(adhesion_id: adhesiones_ids).each do |elem|
      institucion = Contribuyente.find_by(rut: elem.fila[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first)
      dir_principal = institucion.direccion_principal
      
      elementos_adheridos << {
        fecha_adhesion: elem.fila[:fecha_adhesion],
        nombre_institucion: institucion.razon_social,
        rut_institucion: elem.fila[:rut_institucion],
        region: dir_principal.comuna.provincia.region.nombre,
        comuna: dir_principal.comuna.nombre,
        tamano_empresa: elem.fila[:tamaño_empresa],
        tipo_elemento: elem.alcance.nombre,
        nombre_elemento: elem.nombre_del_elemento_v2,
        otro_dato: elem.otro_dato
      }
    end
    elementos_adheridos
  end

  def elementos_certificados
    elementos_certificados = []
    adhesiones = Adhesion.unscoped.where(flujo_id: self.flujo.id)
    #obtengo elementos
    AdhesionElemento.where(adhesion_id: adhesiones.pluck(:id)).each do |adhesion_elemento|
        
      institucion = Contribuyente.find_by(rut: adhesion_elemento.fila[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first)

      auditorias = Auditoria.where(flujo_id: self.flujo.id, con_certificacion: true).order(plazo_cierre: :desc)
      auditoria = nil
      niveles = {}
      fecha_certificacion = "Pendiente"
      vigencia_certificacion = "Pendiente"
      vigente = false
      auditorias.each do |aud|
        flujo = aud.flujo
        convocatoria_id = aud.convocatoria_id
        if convocatoria_id.present?
          #si esta la convocatoria es porque se hace entrega de certificado, mientras no esta certificado?
          minuta_ceremonia = Minuta.find_by(convocatoria_id: convocatoria_id)


          if auditoria.nil? && !minuta_ceremonia.nil? && !minuta_ceremonia.fecha_acta.blank?
            if adhesion_elemento.calcula_porcentaje_cumplimiento(aud, true) == 1
              #primero obtengo la ultima auditoria en la que está certificado
              auditoria = aud

              fecha_certificacion = minuta_ceremonia.fecha_acta.strftime("%F")
              if auditoria.final
                #si es audit final tomo valor general de informe
                tiempo = auditoria.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final
              else
                #si no el plazo cargado en lista de plazos
                tiempo = auditoria.plazo
                #si no esta en la lista de plazos utilizo el de auditoria final
                tiempo = auditoria.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final if tiempo.blank?
              end
              tiempo_calculado = 0
              if tiempo.blank?
                #para version antigua (utilizaba meses)
                tiempo = auditoria.plazo if tiempo.blank?
                #si no existe dato se fuerza a el plazo minimo (1 año/12 meses)
                tiempo = 12 if tiempo.blank?
                tiempo_calculado = tiempo
              else
                #años a meses
                tiempo_calculado = tiempo * 12
              end
              vigencia_certificacion = (minuta_ceremonia.fecha_acta + tiempo_calculado.months)
              vigente = vigencia_certificacion >= Date.today
              vigencia_certificacion = vigencia_certificacion.strftime("%F")
            end
          end

          nivel = adhesion_elemento.cumple_nivel(aud)
          if !nivel.nil?
            _fecha_certificacion = minuta_ceremonia.fecha_acta.strftime("%F")
            
            #cargo el plazo del nivel
            _tiempo = nivel.plazo
            #si nivel no tiene cargo el de auditoria
            _tiempo = aud.plazo if _tiempo.blank?
            #si auditoria no tiene cargo el de aud final
            _tiempo = aud.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final if _tiempo.blank?
            #si no existe plazo final se fuerza al minimo 1 año/12 meses
            _tiempo = 1 if _tiempo.blank?

            _tiempo_calculado = _tiempo * 12

            _vigencia_certificacion = (minuta_ceremonia.fecha_acta + _tiempo_calculado.months)
            _vigente = _vigencia_certificacion >= Date.today
            _vigencia_certificacion = _vigencia_certificacion.strftime("%F")

            if !niveles.has_key?(nivel.id)
              #evito que niveles se repitan
              niveles[nivel.id] = {aud_nivel: nivel, auditoria: aud, fecha_certificacion: _fecha_certificacion, vigencia_certificacion: _vigencia_certificacion, vigente: _vigente}
            end
          end
        else
          #nada
        end
      end

      auditoria = auditorias.last if auditoria.nil?

      if !auditoria.nil? && vigencia_certificacion != "Pendiente"

        #este es de validacion general
        elementos_certificados << {
          auditoria_id: auditoria.id,
          auditoria_nombre: auditoria.nombre,
          tipo_elemento: adhesion_elemento.alcance.nombre,
          id_elemento: adhesion_elemento.id,
          nombre_elemento: adhesion_elemento.nombre_del_elemento_v2,
          fecha_certificacion: fecha_certificacion,
          con_extension: "No",
          vigencia_certificacion: vigencia_certificacion, 
          nombre_acuerdo: adhesion_elemento.adhesion.flujo.nombre_instrumento,
          nombre_estandar: nil,
          nombre_institucion: institucion.razon_social,
          rut_institucion: adhesion_elemento.fila[:rut_institucion],
          region: institucion.direccion_principal.comuna.provincia.region.nombre,
          comuna: institucion.direccion_principal.comuna.nombre,
          vigente: vigente,
          nivel_id: nil,
          otro_dato: adhesion_elemento.otro_dato
        }
      end

      #este es de validacion por nivel
      niveles.each do |nivel_id, data|
        elementos_certificados << {
          auditoria_id: data[:auditoria].id,
          auditoria_nombre: data[:auditoria].nombre,
          tipo_elemento: adhesion_elemento.alcance.nombre,
          id_elemento: adhesion_elemento.id,
          nombre_elemento: adhesion_elemento.nombre_segun_alcance,
          fecha_certificacion: data[:fecha_certificacion],
          con_extension: "No",
          vigencia_certificacion: data[:vigencia_certificacion], 
          nombre_acuerdo: adhesion_elemento.adhesion.flujo.nombre_instrumento,
          nombre_estandar: data[:aud_nivel].estandar_nivel.estandar_homologacion.nombre+"-"+data[:aud_nivel].estandar_nivel.nombre, 
          nombre_institucion: institucion.razon_social,
          rut_institucion: adhesion_elemento.fila[:rut_institucion],
          region: institucion.direccion_principal.comuna.provincia.region.nombre,
          comuna: institucion.direccion_principal.comuna.nombre,
          vigente: data[:vigente],
          nivel_id: nivel_id,
          otro_dato: adhesion_elemento.otro_dato
        }
      end
    end

    elementos_certificados
  end

end
