class EjecucionPresupuestaria < ApplicationRecord
	belongs_to :programa_proyecto_propuesta, optional: true
	belongs_to :centro_de_costo, optional: true
	
	#validates :programa_proyecto_propuesta_id, presence: true
	validates :centro_de_costo_id, presence: true
	validates :año, presence: true
	validates :fecha_transferencia, presence: true
	validates :montos_transferidos, presence: true
  	validates :montos_ejecutados, numericality: { less_than_or_equal_to: :montos_transferidos }
  	validate :fecha_de_transferencia_mayor_adjudicacion, if: -> {fecha_transferencia.present? && programa_proyecto_propuesta.present?}

	 def fecha_de_transferencia_mayor_adjudicacion
	    if fecha_transferencia < programa_proyecto_propuesta.fecha_adjudicacion
	      errors.add(:fecha_transferencia, "Fecha transferencia no puede ser inferior a la fecha de postulación [#{programa_proyecto_propuesta.fecha_adjudicacion}]")
	    end
	end
end
