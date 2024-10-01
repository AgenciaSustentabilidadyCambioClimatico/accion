class MateriaRubroRelacion < ApplicationRecord

	belongs_to :materia_sustancia
	belongs_to :actividad_economica, optional: true
	has_many :materia_rubro_dato_relacions, dependent: :delete_all
	accepts_nested_attributes_for :materia_rubro_dato_relacions, :allow_destroy => true

	validates :materia_sustancia_id, presence: true
	validates :actividad_economica_id, presence: true, if: :updating_record?
	validates :actividad_economica_ids, presence: true, on: :create, if: -> { !self.omite_val }
	#validates_uniqueness_of :materia_sustancia_id, scope: [:actividad_economica_id]
	attr_accessor :actividad_economica_ids, :omite_val

	validate :tupla_existe


	def tupla_existe
		if !omite_val
			if self.new_record?
				#si es nuevo pueden ser varias ae
				self.actividad_economica_ids.each do |ae|
					res = MateriaRubroRelacion.find_by(materia_sustancia_id: self.materia_sustancia_id, actividad_economica_id: ae)
					if !res.blank?
						errors.add(:materia_sustancia_id, "Tupla Materia / Sustancia y Actividad económica #{res.actividad_economica.codigo_ciiuv4} ya existe")
					end
				end
			else
				res = MateriaRubroRelacion.find_by(materia_sustancia_id: self.materia_sustancia_id, actividad_economica_id: self.actividad_economica_id)
				if !res.blank?
					errors.add(:materia_sustancia_id, "Tupla Materia / Sustancia y Actividad económica ya existe")
				end
			end
		end
	end

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
