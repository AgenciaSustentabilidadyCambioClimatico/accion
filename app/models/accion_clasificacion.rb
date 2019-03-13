class AccionClasificacion < ApplicationRecord
	belongs_to :accion, optional: true
	belongs_to :clasificacion

	validates :clasificacion_id, presence: true
end
