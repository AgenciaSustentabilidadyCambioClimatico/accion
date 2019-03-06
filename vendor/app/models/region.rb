class Region < ApplicationRecord
	belongs_to :pais
	has_many :provincias, -> { includes :comunas }
	has_many :comunas, :through => :provincias
	belongs_to :pais
	def nombre_con_articulo
		#de = ['Tarapacá', 'Antofagasta', 'Atacama', 'Coquimbo', 'Valparaíso', 'Araucanía','Los Lagos', 'Aysén', 'Magallanes', 'Los Ríos', 'Arica y Parinacota']
		#del = ["Libertador General Bernardo 0'Higgins", 'Maule', 'Bío-Bío']
		#sin = ['Metropolitana']
		de = [1,2,3,4,5,9,10,11,12,14,15]
		del = [6,7,8]
		sin = [13]

		if de.include?(self.id)
			nombre = "la región de #{self.nombre}"
		elsif del.include?(self.id)
			nombre = "la región del #{self.nombre}"
		elsif sin.include?(self.id)
			nombre = "la región #{self.nombre}"
		else
			nombre = self.nombre
		end
		nombre
	end

	def nombre_sin_articulo
		nombre = nombre_con_articulo
		nombre.gsub(/^la\s/,'').to_s
	end

	def self.romano_to_id(letter)
		{
			I: 		1,
			II: 	2,
			III: 	3,
			IV: 	4,
			V: 		5,
			VI: 	6,
			VII: 	7,
			VIII: 8,
			IX: 	9,
			X: 		10,
			XI: 	11,
			XII: 	12,
			XIII: 13,
			XIV: 	14,
			XV: 	15,
			XVI: 	16,
		}[letter]
	end

	def self.__select
		lista = []
		Region.order(nombre: :asc).map do |c|
			lista << [c.nombre, c.id]
		end
		
		lista
		# [
		# 	['Tarapacá',1],
		# 	['Antofagasta',2],
		# 	['Atacama',3],
		# 	['Coquimbo',4],
		# 	['Valparaíso',5],
		# 	['Libertador General Bernardo O\'Higgins',6],
		# 	['Maule',7],
		# 	['Bío-Bío',8],
		# 	['Araucanía',9],
		# 	['Los Lagos',10],
		# 	['Aysén',11],
		# 	['Magallanes',12],
		# 	['Metropolitana',13],
		# 	['Los Ríos',14],
		# 	['Arica y Parinacota',15]
		# ]
	end

	# ToDo: agregar pais_id o crear una tabla más estándar, en vez de región, ciudad o qué se shó
	def self.por_pais_id
		regiones = {}
		#Region.order(pais_id: :desc, nombre: :asc).all.each do |region|
		#	regiones[region.pais_id] = [] unless regiones.has_key?(region.pais_id)
		#	regiones[region.pais_id] << { id: region.id, nombre: region.nombre }
		#end
		regiones
	end

	def self.rpc
		comunas = []
		rpc = { regiones: {} }
		Region.includes([:provincias]).order(id: :asc).all.each do |r|
		  rpc[:regiones][r.id] = { nombre: r.nombre, provincias: {} } unless rpc[:regiones].has_key?(r.id)
		  r.provincias.each do |p|
		  	unless rpc[:regiones][r.id][:provincias].include?(p.id)
		  		rpc[:regiones][r.id][:provincias][p.id]={nombre: p.nombre, comunas: {} }
		  	end
		  	p.comunas.each do |c|
		  		comunas << "#{c.nombre} #{p.nombre} #{r.nombre}"
		  		rpc[:regiones][r.id][:provincias][p.id][:comunas][c.id] = c.nombre
		  	end
		  end
		end
		rpc
	end
end
