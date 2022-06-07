class ActividadEconomicaContribuyente < ApplicationRecord
	belongs_to :actividad_economica, optional: true
	belongs_to :contribuyente, optional: true
	validates_uniqueness_of :actividad_economica_id, scope: [:contribuyente_id]

  #validates :actividad_economica, presence: true
  validate :ae_presence

  def ae_presence
    errors.add(:actividad_economica, "No puede estar en blanco") if !self.marked_for_destruction? && self.actividad_economica.blank?
  end
  
  def contribuyente
    super || (Contribuyente.unscoped.find(self.contribuyente_id) if self.contribuyente_id.present?)
  end
end
