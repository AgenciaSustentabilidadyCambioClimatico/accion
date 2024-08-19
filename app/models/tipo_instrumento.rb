class TipoInstrumento < ApplicationRecord
  belongs_to :tipo, class_name: :TipoInstrumento, foreign_key: :tipo_instrumento_id, optional: true
  validates :nombre, presence: true
  validates_uniqueness_of :nombre#, { scope: :tipo_instrumento_id }
  validates :descripcion, presence: true

  PROGRAMAS_Y_PROYECTOS_REGIONALES        = 1
  STR_PROGRAMAS_Y_PROYECTOS_REGIONALES    = "Programas y Proyectos de Financiamiento"
  PPP_EJECUTADOS_POR_TERCEROS             = 2
  STR_PPP_EJECUTADOS_POR_TERCEROS         = "Programas o Proyectos Propuestos y Ejecutados por Terceros"
  PPP_PROPUESTOS_Y_EJECUTADOS_POR_AGENCIA = 18
  STR_PPP_PROPUESTOS_Y_EJECUTADOS_POR_AGENCIA = "Programas o Proyectos Propuestos y Ejecutados por la Agencia"
  PPP_PROPUESTOS_AGENCIA_Y_EJECUTADOS_TERCEROS = 3
  PPF                                     = [1,2,3,18]

  ACUERDO_DE_PRODUCCION_LIMPIA            = 4
  STR_ACUERDO_DE_PRODUCCION_LIMPIA        = "Acuerdo de Producción Limpia"

  APLS                                    = [4,5,6,7,8,20]
  
  FONDO_DE_PRODUCCION_LIMPIA              = 10
  STR_FONDO_DE_PRODUCCION_LIMPIA          = "Fondo de Producción Limpia"
  FPL_LINEA_1_1                           = 11
  FPL_LINEA_1_2_1                         = 12
  FPL_LINEA_1_2_2                         = 29
  STR_FPL_LINEA_1_1                       = "Línea 1.1 - Diagnóstico de APL NCH"
  STR_FPL_LINEA_1_2_1                     = "Línea 1.2.1 - Implementación de APL - Fase 1"
  STR_FPL_LINEA_1_2_2                     = "Línea 1.2.2 - Implementación de APL - Fase 2"
  FPL                                     = [11,12,13,14,15,16,17]
  FPL_LINEA_1                             = [11,12,13,29]
  FPL_LINEA_2                             = [14,15]
  FPL_LINEA_3                             = [16]
  STR_FPL_LINEA_3                         = "Línea 3 - Misiones de Cooperación en Producción Limpia"
  FPL_LINEA_4                             = [17]
  STR_FPL_LINEA_4                         = "Línea 4 - Difusión Beneficios APL y Producción Limpia"
  FPL_LINEA_5_1                           = 22
  L1                                      = "L1"
  L5                                      = "L5"
  FPL_EXTRAPRESUPUESTARIO                 = 30

  def self.por_padre(key=:name,object=false,include_parent=true,by_type=nil)
    tipo_instrumento = TipoInstrumento.includes([:tipo])
    tipo_instrumento = tipo_instrumento.where("id = (#{by_type}) OR tipo_instrumento_id = (#{by_type})") unless by_type.blank?
    self.agrupar(
      tipo_instrumento.order(nombre: :asc,tipo_instrumento_id: :asc).all,
      :tipo_instrumento_id,
      :tipo,
      key,
      object,
      include_parent
    )
  end

  def self.por_padre_modelo(key=:name,object=false,include_parent=true,by_type=nil)
    tipo_instrumento = TipoInstrumento.includes([:tipo])
    tipo_instrumento = tipo_instrumento.where("id = (#{by_type}) OR tipo_instrumento_id = (#{by_type})") unless by_type.blank?
    self.agrupar_con_modelo(
      tipo_instrumento.order(nombre: :asc,tipo_instrumento_id: :asc).all,
      :tipo_instrumento_id,
      :tipo,
      key,
      object,
      include_parent
    )
  end

  def self.lineas_asociadas(key=:name,object=false,include_parent=true)
    condicion = [
      'id = (?) OR tipo_instrumento_id = (?)',
      self::FONDO_DE_PRODUCCION_LIMPIA,
      self::FONDO_DE_PRODUCCION_LIMPIA
    ]
    hash = self.agrupar(
      TipoInstrumento.where(condicion)
        .includes([:tipo])
        .order(nombre: :asc,tipo_instrumento_id: :asc)
        .all,
      :tipo_instrumento_id,
      :tipo,
      key,
      object,
      include_parent
    )
    hash[hash.keys[0]]
  end

  def self.__select
    TipoInstrumento.order(tipo_instrumento_id: :desc, nombre: :asc).all.map{|m|[m.nombre,m.id]}
  end

  def self.__select_arbol
    __select_arbol_child(beauty_tree_selector.values)
  end

  def self.__select_arbol_child list, space=""
    ti_list = []
    list.each do |ti|
      ti_list << [space+ti[:name], ti[:id]]
      ti_list += __select_arbol_child(ti[:children].values, space+"&nbsp;&nbsp;") if !ti[:children].blank?
    end
    ti_list
  end

  def self.beauty_tree_selector
    tree = {}
    tis = TipoInstrumento.order(tipo_instrumento_id: :desc, nombre: :asc).all
    tis.each do |ti|
      if ti.tipo_instrumento_id.nil?
        tree[ti.id] = {id: ti.id, name: ti.nombre, children: {}}
      else
        tree[ti.tipo_instrumento_id][:children][ti.id] = {id: ti.id, name: ti.nombre, children: {}}
      end
    end

    tree
  end

  def self.__por_responsable(session)
    #Responsable.where()
  end

  def self.apl(parent_id=4)
    self.__apl_o_fpl_o_ppf(parent_id)
  end

  def self.fpl(parent_id=10)
    self.__apl_o_fpl_o_ppf(parent_id)
  end

  def self.ppf(parent_id=1)
    self.__apl_o_fpl_o_ppf(parent_id)
  end

  def self.__apl_o_fpl_o_ppf(parent_id)
    TipoInstrumento.where("id = (#{parent_id}) OR tipo_instrumento_id = (#{parent_id})").all
  end

  def es_tipo?
    self.tipo_instrumento_id.blank? 
  end

  def es_subtipo?
    self.tipo_instrumento_id.present? 
  end

  def nombre_tipo
    self.es_tipo? ? self.nombre : TipoInstrumento.find_by(id: self.tipo_instrumento_id).nombre
  end

  def nombre_subtipo
    self.es_subtipo? ? self.nombre : "Pendiente de aprobación"
  end

end
