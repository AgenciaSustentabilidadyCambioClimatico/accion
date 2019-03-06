class SeguimientoFpl::ProyectoPagosController < ApplicationController
	before_action :authenticate_user!
	before_action :carga_proyecto

  def orden_pago
    redirect_to root_path if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
  end

  def fecha_pago
    redirect_to root_path if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
  end

	def update
		respond_to do |format|
      @es_orden_pago = proyecto_pagos_params.has_key?("numero_orden_pago")
      if @proyecto_pago.update(proyecto_pagos_params)

        @tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        @tarea_pendiente.save

      	format.html { redirect_to root_path, notice: "Orden de pago actualizada" }
      	flash[:notice] = "Orden de pago actualizada"
        format.js { render js: "window.location.href='#{root_path}'" }
      else
        path = @es_orden_pago ? seguimiento_fpl_proyecto_proyecto_pagos_orden_pago_path(@tarea_pendiente,@proyecto,@proyecto_pago) : seguimiento_fpl_proyecto_proyecto_pagos_fecha_pago_path(@tarea_pendiente,@proyecto,@proyecto_pago)
        format.html { redirect_to path, alert: "Error al actualizar" }
        flash[:alert] = "Error al actualizar"
      	format.js 
      end
    end

	end

	private 

		def proyecto_pagos_params
      params.require(:proyecto_pago).permit(
      	:numero_orden_pago,
      	:fecha_pago_efectiva,
      	:modelo
      )
    end

		def carga_proyecto
			@proyecto = Proyecto.includes(:proyecto_pagos).find(params[:proyecto_id])
			@proyecto_pago = @proyecto.proyecto_pagos.find(params[:id])
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente])
      autorizado? @tarea_pendiente
		end
end