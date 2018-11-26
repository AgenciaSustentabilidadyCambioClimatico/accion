class EncuestaPregunta < ApplicationRecord
	belongs_to :encuesta, optional: true
	belongs_to :pregunta

	validates :pregunta_id, presence: true
end
