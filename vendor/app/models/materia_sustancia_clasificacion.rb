class MateriaSustanciaClasificacion < ApplicationRecord
	belongs_to :materia_sustancia, optional: true
	belongs_to :clasificacion

	#validates :materia_sustancia_id, presence: true
	validates :clasificacion_id, presence: true
end