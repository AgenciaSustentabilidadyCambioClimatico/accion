class DatoRecolectado < ApplicationRecord
	attr :secciones_observadas_pertinencia_factibilidad

	has_one :materia_rubro_dato_relacion
	has_many :dato_productivo_elemento_adheridos

	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates :cpc, presence: true
	validates :medios_verificacion, presence: true
	validates :unidad_base, presence: true
	validates :unidades_compatibles, presence: true

	serialize :unidades_compatibles


	def self.compatibles unidad_b
		if unidad_b.present?
			unidad = unidad_b.to_unit
			td = []
			unidades = Unit.definitions.values
			unidades.each_with_index do |val, index| 
				
				begin
					if !val.prefix? && val.display_name.to_unit =~ unidad
						td.push(val)
					end
				rescue => e

				end
			end
			td = td.map{|k| [k.name.gsub(/[<>]/, '').upcase, k.display_name] }
		end
	end

	def unidades_compatibles_base
		compatibles = self.unidades_compatibles.reject(&:empty?).to_sentence
		"#{self.unidad_base} / #{compatibles}"
	end
end
