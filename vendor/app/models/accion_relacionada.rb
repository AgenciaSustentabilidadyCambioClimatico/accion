class AccionRelacionada < ApplicationRecord
	belongs_to :accion, optional: true
	# belongs_to :accion, optional: true, class_name: :Accion, foreign_key: :accion_relacionada_id
	belongs_to :accion_relacionada, class_name: :Accion, foreign_key: :accion_relacionada_id

	validates :accion_relacionada_id, presence: true
	validates :descripcion, presence: true
end