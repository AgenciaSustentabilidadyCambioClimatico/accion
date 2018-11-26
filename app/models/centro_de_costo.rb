class CentroDeCosto < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates :ano_asignacion, presence: true, format: { with: /(199\d{1}|20\d{2})/i }
	validates :monto_asignacion, presence: true
	validates_numericality_of :ano_asignacion, :monto_asignacion

	def initialize(attributes = {})
		super(normalize(attributes))
	end

	def update(attributes)
		super(normalize(attributes))
	end

	def normalize(attributes)
		unless attributes[:monto_asignacion].blank? 
			attributes[:monto_asignacion] = attributes[:monto_asignacion].to_s.gsub(/[^0-9]/,'').to_i
		end
		attributes
	end
end

