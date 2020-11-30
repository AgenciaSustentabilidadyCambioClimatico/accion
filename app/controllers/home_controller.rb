class HomeController < ApplicationController
	def index
		include_models		= [:tipo_instrumento,:contribuyente,:estado_manifestacion,:persona]
		persona_ids				= @personas.map{|m|m[:id]}
		@manifestaciones	= []#ManifestacionDeInteres.includes(include_models).where(persona_id: persona_ids).order(id: :desc).all
		TareaPendiente.continua_flujo_tareas_plazo_vencido(current_user.id) # DZC continua con el flujo de las tareas con plazo vencido, para que se excluyan de la bandeja de entrada
		@pendientes 			= TareaPendiente.todas_del_(current_user.id) #incluye todas las tareas pendientes del usuario
		
	end

	def consulta_publica_propuestas_acuerdo
		@tarea_pendientes = TareaPendiente.where(tarea_id: Tarea::ID_APL_019)
		@acuerdos = []
		@tarea_pendientes.each do |tp|
			flujo = tp.flujo
			manifestacion_de_interes = flujo.manifestacion_de_interes
			tarea_20 = TareaPendiente.where(flujo_id: flujo.id, tarea_id: Tarea::ID_APL_020).first

			nombre_acuerdo = manifestacion_de_interes.nombre_acuerdo
			estado_consulta = "Abierta"
			estado_consulta = "Cerrada" if !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::NO_INICIADA && tp.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA
			estado_consulta = "Finalizada" if !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA && tp.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA

			@acuerdos << {
				tarea_pendiente_id: tp.id,
				manifestacion_de_interes_id: manifestacion_de_interes.id,
				encuesta_id: tp.tarea.encuesta_id,
				nombre_acuerdo: nombre_acuerdo,
				estado_consulta: estado_consulta
			}
		end
	end
end