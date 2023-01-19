class SeguimientoFpl::ProyectosController < ApplicationController
  protect_from_forgery with: :exception, unless: proc{action_name == 'enviar_pago'}
  before_action :authenticate_user!
  before_action :set_proyecto, except: [:crear_actividad,:index,:calendario,:actualizar_calendario] #only: [:mostrar_ocultar, :iniciar_syc, :enviar_pago, :restitucion, :actualizar_restitucion, :resolucion_contrato, :actualizar_resolucion_contrato, :fecha_efectiva_pago, :actualizar_fecha_efectiva_pago]
	before_action :set_proyecto_calendario, only: [:calendario,:actualizar_calendario]
	before_action :set_tarea_pendiente, only: [:responsables,:actualizar_responsables, 
																						:calendario, :actualizar_calendario, 
																						:solicitud_pago, :enviar_pago,
																						:resolucion_contrato, :actualizar_resolucion_contrato,:restitucion,:actualizar_restitucion]

	def index
		@proyectos = Proyecto.includes([:flujo,:contribuyente]).all
	end

	def mostrar_ocultar
		@proyecto.oculto = !@proyecto.oculto
		@proyecto.save
		render plain: "OK"
	end

	def iniciar_syc
		resultado = @proyecto.iniciar_seguimiento!
		respond_to do |format|
			if resultado[:iniciado]
      	@proyecto.save
        format.html { redirect_to seguimiento_fpl_proyectos_path, notice: "Seguimiento iniciado correctamente" }
      else
        format.html { redirect_to seguimiento_fpl_proyectos_path, alert: resultado[:mensaje] }
      end
    end
	end

	def solicitud_pago
		@proyectos = Proyecto.where(iniciado: true).includes([:rendiciones,:documento_garantias,:centro_de_costo,:proyecto_actividad]).all
	end

	def enviar_pago
		
		@proyectos = Proyecto.where(iniciado: true).includes([:rendiciones,:documento_garantias,:centro_de_costo,:proyecto_actividad]).all
		monto = pago_params[:monto_pagar]
		pp = ProyectoPago.new({
			proyecto_id: @proyecto.id,
			monto: monto
		})
		@correcto = false
		monto_valido = (monto.blank? == false && monto.to_i > 0)
		respond_to do |format|
			@correcto = true if (monto_valido and pp.save)
			if @correcto
				@proyecto.pago_success @tarea_pendiente, pp.id
  			flash.now[:success] = "Pago realizado correctamente"
			else
  			flash.now[:alert] = "Error al realizar pago"
			end
			format.js
		end
	end

	def restitucion
	end

	def resolucion_contrato
		@descargables = @tarea_pendiente.get_descargables
	end

	def fecha_efectiva_pago
		@monto_pagar = 0
	end

	def calendario
		if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
			redirect_to root_path
		end
		@actividades = ProyectoActividad::get_actividades_calendario(@proyecto.id)
		cc = @proyecto.centro_de_costo
		ppagos = @proyecto.proyecto_pagos.where("fecha_pago <= ?", Date.today.end_of_year)
		monto_hasta_hoy = ppagos.where("fecha_pago <= ?", Date.today).sum(:monto) #pagos_hasta_hoy
		montos_hasta_fin_año = ppagos.sum(:monto) #pagos_hasta_fin_año


		#monto_disponible_año_vigente = self.centro_de_costo.blank? ? 0 : ( self.centro_de_costo.monto_asignacion - monto_hasta_hoy )

		@monto_disponible_año_vigente = cc.blank? ? 0 : cc.monto_asignacion - monto_hasta_hoy
		@monto_disponible_menos_compromiso = cc.blank? ? 0 : cc.monto_asignacion - montos_hasta_fin_año
		ultima_fecha_fin = @proyecto.proyecto_actividad.where(proyecto_id: @proyecto.id).maximum(:fecha_finalizacion)
		ultima_fecha_rendicion = @proyecto.rendiciones.where(proyecto_id: @proyecto.id).maximum(:fecha_rendicion) 
		@falta_rendir = ultima_fecha_rendicion.blank? ? true : ultima_fecha_rendicion < ultima_fecha_fin
		@modalidades = Modalidad.as_select
	end

	def responsables
		#redirect_to root_path if @tarea_pendiente.tengo_permiso current_user, @proyecto, true
		redirect_to root_path if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
	end

	# definicion de vistas js que actualizan

	def actualizar_responsables
		### OJO
		@guardado = false
		# cogestor_id fue cambiado, falta implementar la logica de agregar usuarios desde mapa de actores
		if @proyecto.update(proyecto_params_responsables)
			@proyecto.responsables_success proyecto_params_responsables, @tarea_pendiente
  		flash.now[:success] = "Información ingresada correctamente"
  		@guardado = true
		else
  		flash.now[:alert] = "Error al actualizar"
		end

		respond_to do |format|
			format.js {}
		end
	end

	def actualizar_calendario
		respond_to do |format|
			if @proyecto.update(proyecto_params_calendario)
				ultima_fecha_fin = @proyecto.proyecto_actividad.where(proyecto_id: @proyecto.id).maximum(:fecha_finalizacion) 
				ultima_fecha_rendicion = @proyecto.rendiciones.where(proyecto_id: @proyecto.id).maximum(:fecha_rendicion)
				falta_rendir = ultima_fecha_rendicion.blank? ? true : ultima_fecha_rendicion < ultima_fecha_fin
				mensaje_warning = nil
				mensaje_success = nil
				path = root_path
				if falta_rendir
					path = calendario_seguimiento_fpl_proyecto_path(@tarea_pendiente,@proyecto)
					mensaje_warning = "Aún debe completar las rendiciones faltantes" 
				else
					mensaje_success = "Rendiciones listas"
				end
				@proyecto.calendario_success @tarea_pendiente, falta_rendir
				format.html { redirect_to path, flash: { notice: mensaje_success, warning: mensaje_warning } }
			else
				format.html { redirect_to calendario_seguimiento_fpl_proyecto_path(@tarea_pendiente,@proyecto), flash: { error: __list_errors(@proyecto) } }
			end
		end
	end

	def actualizar_fecha_efectiva_pago
		respond_to do |format|
      if @proyecto.update(proyecto_params_fecha_pago_efectiva)
        flash.now[:notice] = "Proyecto actualizado"
		    format.js {}
      else
        flash.now[:alert] = "Error al actualizar"
		    format.js {}
      end
    end
	end
	def actualizar_resolucion_contrato
		respond_to do |format|
			@proyecto.archivo_resolucion = nil
			@proyecto.archivo_contrato = nil
		  if @proyecto.update(proyecto_params_resolucion_contrato)
		  	@proyecto.resolucion_restitucion_success @tarea_pendiente
		    flash[:notice] = "Proyecto actualizado"
		    format.js { render js: "window.location.href='#{root_path}'" }
		  else
		  	@descargables = @tarea_pendiente.get_descargables
		    flash.now[:alert] = "Error al actualizar"
		    format.js {}
		  end
		end
	end

	def actualizar_restitucion
		respond_to do |format|
			if @proyecto.update(proyecto_params_restitucion)
		  	@proyecto.resolucion_restitucion_success @tarea_pendiente
				flash.now[:notice] = "Proyecto actualizado"
				format.js { render js: "window.location.href='#{root_path}'" }
			else
				flash.now[:alert] = "Error al actualizar"
				format.js {}
			end
		end
	end

	private

	def set_tarea_pendiente
		@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente])
		autorizado? @tarea_pendiente
    unless @tarea_pendiente.tengo_permiso? current_user
      flash[:warning] = 'No tiene permiso para acceder a esta tarea'
      redirect_to root_path
    end
	end

	# defino la obtencion de param para cada vista
	def proyecto_params_responsables
		parametros = params.require(:proyecto).permit(
      :coordinador_id,
      :cogestor_id,
      :revisor_tecnico_id,
      :centro_costos_id,
      :fecha_inicio_contrato,
      :fecha_fin_contrato,
      :archivo_resolucion,
      :archivo_resolucion_cache,
      :archivo_contrato,
      :archivo_contrato_cache
  	)
  	parametros[:funcion_a_probar] = :responsables
    parametros
  end

	def proyecto_params_calendario
		params.require(:proyecto).permit(
			:archivo_minuta_reunion,
			:archivo_minuta_reunion_cache,
			rendiciones_attributes: [ 
				:id, 
				:fecha_rendicion,
				:modalidad_id,
				:suma_fpl,
				:_destroy
			]
		)
  end

	def proyecto_params_fecha_pago_efectiva
    parametros = params.require(:proyecto).permit(
    	:fecha_pago_efectiva
    )
	  parametros[:funcion_a_probar] = :fecha_pago_efectiva
    parametros
  end

	def proyecto_params_resolucion_contrato
	  parametros = params.require(:proyecto).permit(
	    :archivo_contrato,
	    :archivo_contrato_cache,
	    :archivo_resolucion,
	    :archivo_resolucion_cache,
      :fecha_inicio_contrato,
      :fecha_fin_contrato
	  )
	  parametros[:funcion_a_probar] = :resolucion_contrato
	  parametros
	end

	def proyecto_params_restitucion
    parametros = params.require(:proyecto).permit(
    	:fecha_restitucion,
    	:monto_restitucion
    )
    parametros[:monto_restitucion] = dinero_params(parametros[:monto_restitucion]) unless parametros[:monto_restitucion].blank?
    parametros[:funcion_a_probar] = :restitucion
    parametros
  end

	def pago_params
		parametros = params.require(:proyecto).permit(:monto_pagar)
		parametros[:monto_pagar] = dinero_params(parametros[:monto_pagar]) unless parametros[:monto_pagar].blank?
		parametros
	end

	# se define dos veces la obtencion de proyecto, una con los demas modelos para no traer data demas cuando no se necesita
	def set_proyecto
		@proyecto = Proyecto.find(params[:id])
	end

	def set_proyecto_calendario
		# 
		@proyecto = Proyecto.includes([:centro_de_costo,:proyecto_pagos,:proyecto_actividad,:rendiciones,:documento_garantias]).find(params[:id])
  end
end
