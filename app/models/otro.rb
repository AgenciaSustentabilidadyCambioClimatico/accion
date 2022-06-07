class Otro < ApplicationRecord
  attr_accessor :rut, :razon_social, :resultado_mostrados, :direccion #sin saber para que sirven ??
  attr_accessor :rut_contribuyente, :nombre_contribuyente
  belongs_to :establecimiento_contribuyente, optional: true, foreign_key: "establecimiento_contribuyente_id"
  belongs_to :alcance, foreign_key: "alcance_id"
  belongs_to :contribuyente
  has_many :adhesion_elementos
  has_many :adhesiones, through: :adhesion_elementos
  serialize :fields_visibility

  mount_uploaders :imagen, ArchivosImagenOtroUploader

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
