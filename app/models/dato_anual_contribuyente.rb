class DatoAnualContribuyente < ApplicationRecord
	belongs_to :contribuyente
	belongs_to :tipo_contribuyente
  belongs_to :rango_venta_contribuyente
  validates :periodo, presence: true, numericality: { only_integer: true }, length: { is: 4 }
  validates :numero_trabajadores, presence: true
  validates :tipo_contribuyente_id, presence: true
  validates :rango_venta_contribuyente_id, presence: true
  validates_uniqueness_of :periodo, scope: [:contribuyente_id], unless: proc{self.periodo.blank?}

  
  def contribuyente
    super || (Contribuyente.unscoped.find(self.contribuyente_id) if self.contribuyente_id.present?)
  end
end
