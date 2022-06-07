class Maquinaria < ApplicationRecord
  attr_accessor :rut, :razon_social, :resultado_mostrados
  belongs_to :establecimiento_contribuyente, optional: true
  attr_accessor :rut_contribuyente, :nombre_contribuyente

  #Se agrega foreign_key debido a error en nombre de fk
  belongs_to :contribuyente, optional: true
  has_many :adhesion_elementos
  has_many :adhesiones, through: :adhesion_elementos

  mount_uploaders :archivos_imagen, ArchivosImagenMaquinariaUploader

  serialize :fields_visibility

  validates :nombre_maquinaria, presence: true
  validates :contribuyente_id, presence: true

  validates :numero_serie, presence: { if: -> { patente.blank? } }
  validates :patente, presence: { if: -> { numero_serie.blank? } }

  default_scope { where("fecha_eliminacion IS NULL") }

  
  
  def contribuyente
    super || (Contribuyente.unscoped.find(self.contribuyente_id) if self.contribuyente_id.present?)
  end

  def adherido_activo?
    flujos_asociados = Flujo.where(id: self.adhesiones.pluck('flujo_id')).where(terminado: false)
    flujos_asociados.count > 0
  end
  def adherido_inactivo?
    flujos_asociados = Flujo.where(id: self.adhesiones.pluck('flujo_id')).where(terminado: true)
    flujos_asociados.count > 0
  end
end
