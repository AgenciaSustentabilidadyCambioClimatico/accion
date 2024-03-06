class TareaPendientesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_continua_flujo_tareas_vencidas 

  def acuerdos
    gg = TareaPendiente.todas_del_(current_user.id).group_by {|f| f.flujo.id }# DZC continua con el flujo de las tareas con plazo vencido, para que se excluyan de la bandeja de entrada
    rr = []
    gg.each do |index, value|
      rr << value.first
    end
    @algo = TareaPendiente.todas_del_(current_user.id) + rr

    @pendientes     = @algo
  end

	def proyectos_ppf
		@pendientes = TareaPendiente.proyectos_de_(current_user.id)
	end


	def seguimientos_fpl
		@pendientes = TareaPendiente.seguimientos_de_(current_user.id)
	end

	def auditoria_sin_elementos_adheridos
		
		tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
		errores = "Aún no se han aprobado elementos para este APL."
		flash[:warning] = errores
		redirect_to root_path
	end

	private
		#DZC 
		def set_continua_flujo_tareas_vencidas # DZC continua con el flujo de las tareas con plazo vencido, para que se excluyan de la bandeja de entrada
			TareaPendiente.continua_flujo_tareas_plazo_vencido(current_user.id)
		end
end
