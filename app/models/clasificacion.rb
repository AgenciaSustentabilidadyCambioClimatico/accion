class Clasificacion < ApplicationRecord
  has_many :accion_clasificaciones, -> {includes :accion}, foreign_key: :clasificacion_id, dependent: :destroy
  has_many :materia_sustancia_clasificaciones, -> {includes :materia_sustancia}, foreign_key: :clasificacion_id, dependent: :destroy

  belongs_to :clasificacion_padre, class_name: :Clasificacion, foreign_key: :clasificacion_id, optional: true

  validates_length_of :nombre, minumum: 1, maximum: 80, allow_blank: false
  validates_length_of :descripcion, minumum: 1, maximum: 350, allow_blank: false
  validates :referencia, presence: true
  validates :es_meta, presence: true, unless: -> { es_meta == false }

  mount_uploader :imagen, ArchivoImagenClasificacionUploader
  mount_uploader :icono, ArchivoIconoClasificacionUploader

  def self.descritas(solo_metas=false)
    descripcion = {}
    record_set = solo_metas ? Clasificacion.where(es_meta: true).all : Clasificacion.all
    record_set.each do |clasificacion|
      descripcion[clasificacion.id] = {
        clasificacion_id: clasificacion.clasificacion_id,
        nombre: clasificacion.nombre,
        descripcion: clasificacion.descripcion,
        referencia: clasificacion.referencia,
        es_meta: clasificacion.es_meta, #redudante si solo_metas == true
      }
    end
    descripcion
  end

  def self.acciones_descritas
    descripcion = {}
    clasificaciones = Clasificacion.includes([:accion_clasificaciones]).where(es_meta: false).all
    clasificaciones.each do |clasificacion|
      descripcion[clasificacion.id] = clasificacion.accion_clasificaciones.map do |ac|
        accion = ac.accion
        {
          id: accion.id,
          nombre: accion.nombre,
          descripcion: accion.descripcion,
          meta_id: accion.meta_id,
          debe_asociar_materia_sustancia: accion.debe_asociar_materia_sustancia,
          medio_de_verificacion_generico: accion.medio_de_verificacion_generico
        }
      end
    end
    descripcion
  end

  def self.materia_sustancia_descritas
    descripcion = {}
    clasificaciones = Clasificacion.includes([:materia_sustancia_clasificaciones]).where(es_meta: false).all
    clasificaciones.each do |clasificacion|
      descripcion[clasificacion.id] = clasificacion.materia_sustancia_clasificaciones.map do |msc|
        ms = msc.materia_sustancia
        {
          id: ms.id,
          meta_id: ms.meta_id,
          unidad_base: ms.unidad_base, #DZC se corrige modificación en tabla materia sustancia
          nombre: ms.nombre,
          descripcion: ms.descripcion,
          posee_una_magnitud_fisica_asociada: ms.posee_una_magnitud_fisica_asociada
        }
      end
    end
    descripcion
  end

  def self.por_padre(key=:name,object=false,include_parent=true)
    self.agrupar(
      Clasificacion.includes([:clasificacion_padre]).order(nombre: :asc, clasificacion_id: :asc).all,
      :clasificacion_id,
      :clasificacion_padre,
      key,
      object,
      include_parent
    )
  end

  def todos_mis_hijos(id=true, meta=false)
    _todos_mis_hijos(self, id, meta)
  end

  def _todos_mis_hijos(clasif, id, meta)
    clasificaciones = Clasificacion.where(clasificacion_id: clasif.id)
    clasificaciones = clasificaciones.where(es_meta: true) if meta
    if id
      lista = [clasif.id]
    else
      lista = [clasif]
    end
    if clasificaciones.count > 0
      clasificaciones.each do |clasificacion|
        lista += _todos_mis_hijos(clasificacion, id, meta)
      end
    end
    lista
  end

  def mi_padre_mayor
    if self.clasificacion_id.blank?
      return self
    else
      return self.clasificacion_padre.mi_padre_mayor
    end
  end

  def acuerdos
    manifestacion_de_intereses_ids = Flujo.where(id: self.set_metas_acciones.pluck(:flujo_id).uniq).pluck(:manifestacion_de_interes_id)
    ManifestacionDeInteres.where(id: manifestacion_de_intereses_ids).where("firma_fecha IS NOT NULL")
  end

  def set_metas_acciones
    ids = todos_mis_hijos(true)
    SetMetasAccion.joins("LEFT JOIN accion_clasificaciones ON accion_clasificaciones.accion_id = set_metas_acciones.accion_id LEFT JOIN materia_sustancia_clasificaciones ON materia_sustancia_clasificaciones.materia_sustancia_id = set_metas_acciones.materia_sustancia_id")
                  .joins("INNER JOIN flujos ON flujos.id = set_metas_acciones.flujo_id INNER JOIN manifestacion_de_intereses ON manifestacion_de_intereses.id = flujos.manifestacion_de_interes_id")
                  .where("accion_clasificaciones.clasificacion_id IN (#{ids.join(",")}) OR materia_sustancia_clasificaciones.clasificacion_id  IN (#{ids.join(",")})")
                  .where("manifestacion_de_intereses.firma_fecha IS NOT NULL")
                  .distinct
  end

  def set_metas_acciones_de_meta
    ids = todos_mis_hijos(true)
    SetMetasAccion.joins("LEFT JOIN acciones ON acciones.id = set_metas_acciones.accion_id LEFT JOIN materia_sustancias ON materia_sustancias.id = set_metas_acciones.materia_sustancia_id")
                  .joins("INNER JOIN flujos ON flujos.id = set_metas_acciones.flujo_id INNER JOIN manifestacion_de_intereses ON manifestacion_de_intereses.id = flujos.manifestacion_de_interes_id")
                  .where("acciones.meta_id IN (#{ids.join(",")}) OR materia_sustancias.meta_id IN (#{ids.join(",")})")
                  .where("manifestacion_de_intereses.firma_fecha IS NOT NULL")
                  .distinct
  end

  def empresas
    rut_empresas = []
    self.elementos.each do |adhesion_elemento|
      rut_empresas << adhesion_elemento.fila[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first
    end
    rut_empresas.uniq
  end

  def elementos
    #si esque entendí la relación:
    #Con mi clasificación debo obtener las setmetasacciones
    #con las setmetasacciones obtengo los alcances
    #con los alcances obtengo las adhesioneselementos
    #con las adhesioneselementos obtengo las empresas adheridas
    #go
    alcances_ids = []
    flujos_ids = []
    self.set_metas_acciones.select(:alcance_id, :flujo_id).each do |accion|
      alcances_ids << accion.alcance_id
      flujos_ids << accion.flujo_id
    end
    adhesiones_ids = Adhesion.where(flujo_id: flujos_ids).pluck(:id)
    AdhesionElemento.where(adhesion_id: adhesiones_ids, alcance_id: alcances_ids)
  end

  def set_metas_acciones_comprometidas(manifestacion_de_interes)
    ids = todos_mis_hijos(true)
    SetMetasAccion.joins("LEFT JOIN accion_clasificaciones ON accion_clasificaciones.accion_id = set_metas_acciones.accion_id LEFT JOIN materia_sustancia_clasificaciones ON materia_sustancia_clasificaciones.materia_sustancia_id = set_metas_acciones.materia_sustancia_id")
                  .where("accion_clasificaciones.clasificacion_id IN (#{ids.join(",")}) OR materia_sustancia_clasificaciones.clasificacion_id IN (#{ids.join(",")})")
                  .where("set_metas_acciones.flujo_id = #{manifestacion_de_interes.flujo.id}")
                  .distinct
                  
    #SetMetasAccion.where(meta_id: self.todos_mis_hijos(true, false)).where(flujo_id: manifestacion_de_interes.flujo.id)
  end

  def set_metas_acciones_comprometidas_de_meta(manifestacion_de_interes)
    SetMetasAccion.joins("LEFT JOIN acciones ON acciones.id = set_metas_acciones.accion_id LEFT JOIN materia_sustancias ON materia_sustancias.id = set_metas_acciones.materia_sustancia_id")
                  .where("acciones.meta_id = #{self.id} OR materia_sustancias.meta_id = #{self.id} OR set_metas_acciones.meta_id = #{self.id}")
                  .where("set_metas_acciones.flujo_id = #{manifestacion_de_interes.flujo.id}")
                  .distinct
                  
    #SetMetasAccion.where(meta_id: self.todos_mis_hijos(true, false)).where(flujo_id: manifestacion_de_interes.flujo.id)
  end

  def metas_comprometidas(manifestacion_de_interes)
    #metas = SetMetasAccion.where(flujo_id: manifestacion_de_interes.flujo.id).pluck(:meta_id)
    #hijos = self.todos_mis_hijos(false, true)
    #hijos.select{|clasif| metas.include?(clasif.id)}
    acciones_comprometidas = self.set_metas_acciones_comprometidas(manifestacion_de_interes).select(:id).map{|accion| accion.id}
    if acciones_comprometidas.blank?
      return []
    else
      return Clasificacion.joins("LEFT JOIN acciones ON acciones.meta_id = clasificaciones.id LEFT JOIN materia_sustancias ON materia_sustancias.meta_id = clasificaciones.id INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = acciones.id OR set_metas_acciones.materia_sustancia_id = materia_sustancias.id OR set_metas_acciones.meta_id = clasificaciones.id")
                    .where("set_metas_acciones.id IN (#{acciones_comprometidas.join(',')})")
                    .distinct
    end
  end

  def elementos_comprometidos(manifestacion_de_interes, vista="clasificaciones")
    alcances_ids = []
    if vista == "clasificaciones"
      alcances_ids = self.set_metas_acciones_comprometidas(manifestacion_de_interes).select("set_metas_acciones.alcance_id").map{|accion| accion.alcance_id}
    else
      alcances_ids = self.set_metas_acciones_comprometidas_de_meta(manifestacion_de_interes).select("set_metas_acciones.alcance_id").map{|accion| accion.alcance_id}
    end
    adhesiones_ids = Adhesion.where(flujo_id: manifestacion_de_interes.flujo.id).pluck(:id)
    AdhesionElemento.where(adhesion_id: adhesiones_ids, alcance_id: alcances_ids)
  end

  def empresas_comprometidas(manifestacion_de_interes, vista="clasificaciones")
    rut_empresas = []
    self.elementos_comprometidos(manifestacion_de_interes, vista).each do |adhesion_elemento|
      rut_empresas << adhesion_elemento.fila[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first
    end
    rut_empresas.uniq
  end

  def cumplimiento_promedio(manifestacion_de_interes, vista="clasificaciones")
    acciones = []
    if vista == "clasificaciones"
      acciones = self.set_metas_acciones_comprometidas(manifestacion_de_interes)
    else
      acciones = self.set_metas_acciones_comprometidas_de_meta(manifestacion_de_interes)
    end
    cantidad = acciones.count
    if cantidad == 0
      return 0.to_f
    else
      suma = 0
      acciones.each do |accion|
        suma += accion.obtiene_procentaje_cumplimiento.gsub("%","").to_f
      end
      return (suma/cantidad).round(2)
    end
  end
end