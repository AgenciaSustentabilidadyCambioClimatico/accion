class HomeController < ApplicationController
	def index
		include_models		= [:tipo_instrumento,:contribuyente,:estado_manifestacion,:persona]
		persona_ids				= @personas.map{|m|m[:id]}
		@manifestaciones	= []#ManifestacionDeInteres.includes(include_models).where(persona_id: persona_ids).order(id: :desc).all
		TareaPendiente.continua_flujo_tareas_plazo_vencido(current_user.id) # DZC continua con el flujo de las tareas con plazo vencido, para que se excluyan de la bandeja de entrada
		@pendientes 			= TareaPendiente.todas_del_(current_user.id) #incluye todas las tareas pendientes del usuario
		
	end
end