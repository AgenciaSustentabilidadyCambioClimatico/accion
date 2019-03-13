class Cargo < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates_uniqueness_of :nombre

	ROOT 					= 1
	ADMIN 				= 2
	USER 					= 3
	BASIC 				= [ROOT, ADMIN, USER]


	COORDINADOR 	= 8
	PERIODISTA		= 16

	AGENCIA				= [COORDINADOR,PERIODISTA]
	
	DUEÑO					= 11
	DIRECTOR			= 12
	REPRESENTANTE	= 13
	ENCARGADO_INS	= 14
	ENCARGADO_EST	= 15

	# PROPONENTE		= 28

	INSTITUCION 	= [DUEÑO,DIRECTOR,REPRESENTANTE,ENCARGADO_INS]

	#Jamás podremos borrar los cargos root, admin ni user
	def destroy
		unless BASIC.include?(self.id) || INSTITUCION.include?(self.id)
			super
		end
	end

	def self.__select
		Cargo.where('id NOT IN (?)',[Cargo::ROOT,Cargo::USER]).all.map {|m|[m.nombre,m.id]}
	end

	def self.__normalizar(cargos)
		normalizados = cargos
		if cargos.is_a?(Array)
			cargos.each do |c|
				if Cargo::INSTITUCION.include?(c)
					normalizados = (Cargo::INSTITUCION+cargos).uniq.sort
					break
				end
			end
		end
		normalizados
	end
end