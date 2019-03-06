class TipoAporte < ApplicationRecord
	has_many :proyecto_actividad
	
	validates :nombre, presence: true
	validates :descripcion, presence: true

	APORTE_PROPIO_VALORADO 		= 1
	APORTE_PROPIO_LIQUIDO			= 2
	SOLICITADO_AL_FONDO				=	3

	def self.id_por_nombre(nombre)
		eval("TipoAporte::#{nombre.upcase}")
	end

end