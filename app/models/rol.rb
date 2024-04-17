class Rol < ApplicationRecord
  validates :nombre, uniqueness: true
  validates :descripcion, presence: true
  
  PROPONENTE                           = 1
  REVISOR_TECNICO                      = 2
  COGESTOR                             = 3
  PATROCINADOR                         = 4
  FINANCISTA                           = 5
  PRENSA                               = 6
  COORDINADOR                          = 7 # en PPF se llama responsable_coordinacion_postulacion_y_seguimiento, y responsable_coordinacion_ejecucion_seguimiento, coexistiendo ambos
  JEFE_DE_LINEA                        = 9
  PARTE_INTERESADA_RELEVANTE           = 11
  FIRMANTE                             = 12
  VALIDADOR                            = 13
  AUDITOR                              = 14
  NEGOCIADOR                           = 15
  COMITE_COORDINADOR                   = 16
  RESPONSABLE_CUMPLIMIENTO_COMPROMISOS = 17
  CARGADOR_DATOS_ACUERDO               = 18 # en PPF se llama usuario_carga_datos
  RESPONSABLE_ENTREGABLES              = 19 # en PPF se llama usuario_visitas
  CERTIFICADA                          = 22
  SISTEMA                              = 25
  ENCARGADO_DE_GESTION_ADMINISTRATIVA  = 26
  ENCARGADO_VALORES                    = 27
  ENCARGARDO_DE_REGISTRO_DE_PAGOS      = 28
  ENCARGADO_DE_EJECUCION_DE_PAGOS      = 29
  REVISOR_CONTABLE                     = 30
  # ELABORADOR_PROPUESTA                 = 32
  RESPONSABLE_ELABORACION_PROPUESTA    = 33 # en PPF se llama responsable_elaboracion_propuesta_y_seguimiento
  REVISOR_JURIDICO                     = 34
  JEFE_DE_LINEA_PROVEEDORES            = 35
  REVISOR_PROVEEDORES                  = 36
  REVISOR_COMENTARIOS                  = 37
  #REVISOR_JURIDICO_FPL                 = 38
  #REVISOR_TECNICO_FPL                  = 39
  REVISOR_FINANCIERO                   = 40
  #JEFE_DE_LINEA_FPL                    = 41
  #ENCARGADO_ENTREGABLES_DIAGNOSTICO   = 10
  #REVISOR_TECNICO_INFORME_DE_IMPACTOS = 20
  #REVISOR_TECNICO_AUDITORIAS         = 21

  STR_PROPONENTE                           = "Proponente"
  STR_REVISOR_TECNICO                      = "Revisor Técnico"
  STR_COGESTOR                             = "Cogestor"
  STR_PATROCINADOR                         = "Patrocinador"
  STR_FINANCISTA                           = "Financista"
  STR_PRENSA                               = "Prensa"
  STR_COORDINADOR                          = "Coordinador"
  STR_JEFE_DE_LINEA                        = "Jefe De Línea"
  STR_PARTE_INTERESADA_RELEVANTE           = "Parte Interesada Relevante"
  STR_FIRMANTE                             = "Firmante"
  STR_VALIDADOR                            = "Validador"
  STR_AUDITOR                              = "Auditor"
  STR_NEGOCIADOR                           = "Negociador"
  STR_COMITE_COORDINADOR                   = "Comité Coordinador"
  STR_RESPONSABLE_CUMPLIMIENTO_COMPROMISOS = "Responsable Cumplimiento Compromisos"
  STR_CARGADOR_DATOS_ACUERDO               = "Cargador Datos Acuerdo"
  STR_RESPONSABLE_ENTREGABLES              = "Responsable Entregables"
  STR_CERTIFICADA                          = "Certificada"
  STR_SISTEMA                              = "Sistema"
  STR_ENCARGADO_DE_GESTION_ADMINISTRATIVA  = "Encargado De Gestión Administrativa"
  STR_ENCARGADO_VALORES                    = "Encargado Valores"
  STR_ENCARGARDO_DE_REGISTRO_DE_PAGOS      = "Encargado De Registro de Pagos"
  STR_ENCARGADO_DE_EJECUCION_DE_PAGOS      = "Encargado De Ejecución de Pagos"
  STR_REVISOR_CONTABLE                     = "Revisor Contable"
  # STR_ELABORADOR_PROPUESTA                 = "Elaborador Propuesta"
  STR_RESPONSABLE_ELABORACION_PROPUESTA    = "Responsable Elaboración Propuesta"
  STR_REVISOR_JURIDICO                     = "Revisor jurídico"
  STR_JEFE_DE_LINEA_PROVEEDORES            = "Jefe de linea proveedores"
  STR_REVISOR_PROVEEDORES                  = "Revisor proveedores"
  STR_REVISOR_COMENTARIOS                  = "Revisor de comentarios"
  

  def self.__select
    Rol.order(nombre: :asc).all.map {|m|[m.nombre,m.id]}
  end
end
