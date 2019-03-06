class Provincia < ApplicationRecord
	has_many :comunas
	belongs_to :region

	# ToDo: crear tabla provincias
	def self.por_region_id
		provincias = {}
		#Provincia.order(region_id: :desc, nombre: :asc).all.each do |provincia|
		#	provincias[provincia.region_id] = [] unless provincias.has_key?(provincia.region_id)
		#	provincias[provincia.region_id] << { id: provincia.id, nombre: provincia.nombre }
		#end
		provincias
	end
end