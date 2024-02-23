class Actividad < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true

	has_many :actividad_por_lineas
end
