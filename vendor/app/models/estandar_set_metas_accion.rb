class EstandarSetMetasAccion < ApplicationRecord
	belongs_to :estandar_homologacion
	belongs_to :accion
	belongs_to :materia_sustancia, optional: true
	belongs_to :meta, optional: true, foreign_key: :meta_id, class_name: :Clasificacion
	belongs_to :alcance, optional: true
	
	validates :accion_id, presence: true
	validates :meta_id, presence: true
	validates :alcance_id, presence: true
	validates :descripcion_accion, presence: true
	validates :detalle_medio_verificacion, presence: true
end
