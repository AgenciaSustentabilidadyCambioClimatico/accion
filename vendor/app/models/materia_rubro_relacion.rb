class MateriaRubroRelacion < ApplicationRecord
	has_many :materia_rubro_dato_relacions, dependent: :delete_all
	accepts_nested_attributes_for :materia_rubro_dato_relacions, :allow_destroy => true

	validates :materia_sustancia_id, presence: true
	validates :actividad_economica_id, presence: true
	validates_uniqueness_of :materia_sustancia_id, scope: [:actividad_economica_id]

	belongs_to :materia_sustancia
	belongs_to :actividad_economica

	def recolectados
		arr = []
		r = self.materia_rubro_dato_relacions
		if r.present?
			pro =  DatoRecolectado.where(id: r.pluck(:dato_recolectado_id))
			pro.each do |val|
  			arr << val.nombre
			end
		end
		arr
	end
end
