class EstadoTareaPendiente < ApplicationRecord
	NO_INICIADA						= 1 #DZC NO_INICIADA SE UTILIZA CUANDO LA TAREA ESTA PENDIENTE Y DISPONIBLE PARA EL USUARIO
	ENVIADA								= 2 #DZC ENVIADA SE UTILIZA CUANDO LA TAREA ESTA TERMINADA
	ANULADA								= 7 #Uso principal en apl-001 para anular tarea

	#DZC no se esta usando
	# DEVUELTA_CON_ERRORES	= 3
	# REENVIADA							= 4
	# ACEPTADA							= 5
	# INICIADA							= 6

	def nombre_historial
		case self.id
		when EstadoTareaPendiente::NO_INICIADA
			return "En curso"
		when EstadoTareaPendiente::ENVIADA
			return "Ejecutada"
		when EstadoTareaPendiente::ANULADA
			return "Anulada por proponente"
		end
	end
end