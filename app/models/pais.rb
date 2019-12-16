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

	def beauty_tree_selector(checkeds=[])
		tree = []
		self.regiones.each do |region|
			#PROVINCIAS
	  		children_region = []
	  		region.provincias.each do |provincia|
	  			#COMUNAS
	  			children_provincia = []
	  			provincia.comunas.each do |comuna|
	  				status_comuna = "unchecked"
	  				status_comuna = "checked" if checkeds.include?(comuna.id)
	  				children_provincia << {id: comuna.id, name: comuna.nombre, status: status_comuna, data: {type: 'comuna'}, children: []}
	  			end
	  			#COMUNAS

	  			children_provincia_checked = children_provincia.select{|child| child[:status] == 'checked'}.size
		  		children_provincia_unchecked = children_provincia.select{|child| child[:status] == 'unchecked'}.size
		  		children_provincia_indeterminate = children_provincia.select{|child| child[:status] == 'indeterminate'}.size
		  		status_provincia = "unchecked"
		  		if children_provincia.size > 0
		  			status_provincia = 'checked' if children_provincia.size == children_provincia_checked
		  			status_provincia = "indeterminate" if children_provincia_indeterminate > 0 || (children_provincia_unchecked > 0 && children_provincia_unchecked != children_provincia.size)
		  		else
		  			status_provincia = "checked" if checkeds.include?(provincia.id)
		  		end
					children_region << {id: provincia.id, name: provincia.nombre, status: status_provincia, data: {type: 'provincia'}, children: children_provincia}
	  		end
	  		#PROVINCIAS

	  		children_region_checked = children_region.select{|child| child[:status] == 'checked'}.size
	  		children_region_unchecked = children_region.select{|child| child[:status] == 'unchecked'}.size
	  		children_region_indeterminate = children_region.select{|child| child[:status] == 'indeterminate'}.size
	  		status_region = "unchecked"
	  		if children_region.size > 0
	  			status_region = 'checked' if children_region.size == children_region_checked
	  			status_region = "indeterminate" if children_region_indeterminate > 0 || (children_region_unchecked > 0 && children_region_unchecked != children_region.size)
	  		else
	  			status_region = "checked" if checkeds.include?(region.id)
	  		end
			tree << {id: region.id, name: region.nombre, status: status_region, data: {type: 'región'}, children: children_region}
		end
		tree

	end
end