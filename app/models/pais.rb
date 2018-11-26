class Pais < ApplicationRecord
	#validates :capital_id, presence: true
	validates :nombre, presence: true
	# validates :nombre_local, presence: true
	# validates :continente, presence: true
	# validates :region, presence: true
	# validates :codigo_corto, presence: true
	# validates :codigo_largo, presence: true
	has_many :regiones

	CHILE=29

	def self.opciones_por_continente(primero="Sudamérica")
		continentes = {}
		self.order(continente: :asc, nombre: :asc).each do |pais|
			if pais.vigente
				continentes[pais.continente] = [] unless continentes.has_key?(pais.continente)
				continentes[pais.continente] << [pais.nombre, pais.id]
			end
		end
		primero = continentes.slice(primero).map{|continente,paises|[continente, paises]}
		resto 	= continentes.except(primero).map{|continente,paises|[continente, paises]}
		return (primero+resto)
	end
end