class ActividadEconomicaContribuyente < ApplicationRecord
	belongs_to :actividad_economica, optional: true
	belongs_to :contribuyente, optional: true
	validates_uniqueness_of :actividad_economica_id, scope: [:contribuyente_id]

  validates :actividad_economica, presence: true

  
  def contribuyente
    super || (Contribuyente.unscoped.find(self.contribuyente_id) if self.contribuyente_id.present?)
  end
end
