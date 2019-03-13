class ActividadEconomicaContribuyente < ApplicationRecord
	belongs_to :actividad_economica
	belongs_to :contribuyente, optional: true
	validates_uniqueness_of :actividad_economica_id, scope: [:contribuyente_id]
end
