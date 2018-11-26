class SeguimientoFpl::ModCalendarioController < ApplicationController
	before_action :authenticate_user!
	before_action :carga_proyecto, except: [:editar_actividad]
	before_action :set_proyecto, only: [:editar_actividad]

	def edit
		@actividades = ProyectoActividad::get_actividades_calendario(@proyecto.id)
		cc = @proyecto.centro_de_costo
		ppagos = @proyecto.proyecto_pagos.where("fecha_pago <= ?", Date.today.end_of_year)
		monto_hasta_hoy = ppagos.where("fecha_pago <= ?", Date.today).sum(:monto) #pagos_hasta_hoy
		montos_hasta_fin_año = ppagos.sum(:monto) #pagos_hasta_fin_año
		@monto_disponible_año_vigente = cc.monto_asignacion - monto_hasta_hoy
		@monto_disponible_menos_compromiso = cc.monto_asignacion - montos_hasta_fin_año
		ultima_fecha_fin = @proyecto.proyecto_actividad.where(proyecto_id: @proyecto.id).maximum(:fecha_finalizacion)
		ultima_fecha_rendicion = @proyecto.rendiciones.where(proyecto_id: @proyecto.id).maximum(:fecha_rendicion) 
		@falta_rendir = ultima_fecha_rendicion.blank? ? true : ultima_fecha_rendicion < ultima_fecha_fin
		
	end

	def editar_actividad
		
	end

	def update

	end

	private 
		def item_params
	      params.require(:actividad_item).permit(
	      	{archivos_tecnica: []},
	      	{archivos_respaldo: []},
	      	:estado_tecnica_id,
	      	:estado_respaldo_id,
	      	:observacion_tecnica,
	      	:observacion_respaldo
	      )
	    end

		def set_proyecto
			@proyecto = Proyecto.includes([:centro_de_costo,:proyecto_pagos,:proyecto_actividad,:rendiciones,:documento_garantias]).find(params[:proyecto_id])
			@glosas = Glosa.all
			@tipo_aportes = TipoAporte.all
			@modalidades = Modalidad.as_select
		end
		def carga_proyecto
			@test_permisos = 1
			@proyecto = Proyecto.includes([:centro_de_costo,:proyecto_pagos,:proyecto_actividad,:rendiciones,:documento_garantias]).find(params[:id])
			@glosas = Glosa.all
			@tipo_aportes = TipoAporte.all
			@modalidades = Modalidad.as_select
		end

end