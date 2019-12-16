class ActualizarComiteAcuerdosController < ApplicationController
	before_action :authenticate_user!
	skip_before_action :verify_authenticity_token, only: [:mostrar_informe, :reload_informe]
	before_action :set_tarea_pendiente
	before_action :set_flujo
	before_action :set_informe
	before_action :set_manifestacion_de_interes

	def index
	end

	def guardar_archivos_anexos_posteriores_firmas
		@informe.accion = action_name # DZC 2018-11-15 14:43:27 se agrega para evitar validaciones
		respond_to do |format|
			
			archivos_previos =[]
			archivos_nuevos =[]
			@informe.archivos_anexos_posteriores_firmas.each do |archivo|
				
				unless (params[:por_eliminar].present? && params[:por_eliminar].include?(archivo.file.filename))
					archivos_previos << Pathname.new(archivo.path).open
				end
			end
			if !informe_archivos_anexos_posteriores_firma_params[:archivos_anexos_posteriores_firmas].blank?
				informe_archivos_anexos_posteriores_firma_params[:archivos_anexos_posteriores_firmas].each do |archivo|
					
					unless (params[:por_eliminar].present? && params[:por_eliminar].include?(archivo.original_filename)) 
						archivos_nuevos <<  archivo
					end
				end
			end
			@informe.assign_attributes(archivos_anexos_posteriores_firmas: archivos_previos+archivos_nuevos)
			r_to = actualizar_comite_acuerdos_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes, tab_metas: true)
			@informe.solo_guarda_archivos = true #DZC 2019-06-11 17:12:18 se agrega para evitar validación del atributo :con_extension
			if @informe.save
				@informe.update(necesita_evidencia: false)
				@informe.solo_guarda_archivos = false #DZC 2019-06-13 12:44:47 se agrega para mantener validaciones desde vista
				format.js { 
          flash.now[:success] = 'Archivos guardados.'
          @set_metas_accion = SetMetasAccion.new
          @set_metas_accion.anexo = params[:anexo]
          
          render js: "window.location='#{r_to}'"
        }
        format.html {
        	redirect_to r_to, notice: 'Archivos guardados.'
        }
      else
      	format.js { 
          flash[:error] = "No se guardaron los archivos por los siguientes errores: #{@informe.errors.full_messages.to_sentence}"
          @informe.solo_guarda_archivos = false
          render js: "window.location='#{r_to}'"
        }
			end	
		end		
	end

	def guardar_comite
		@informe.assign_attributes(informe_params)
		respond_to do |format|
			r_to = actualizar_comite_acuerdos_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes)
			@informe.auditorias = params[:informe_acuerdo][:auditorias]
			@informe.auditorias = [] if @informe.auditorias.nil? #DZC solución Diego para audits nulo
   		if @informe.valid?
   			@informe.save
				@informe.update(necesita_evidencia: true)
				audits_ids = []
				Auditoria.where(flujo_id: @flujo.id).where.not(id: @informe.auditorias.map{|a| a[:id]}).delete_all #DZC busca y elimina los audits existentes y relacionados con esta instancia de informe, y que el usuario decidio no mantener
				
				@informe.auditorias.each do |aud_data|
					audits_ids << aud_data[:id] if aud_data[:id] != "no"
					aud = (aud_data[:id] == "no") ? Auditoria.new : Auditoria.find(aud_data[:id])
					aud.assign_attributes({
						flujo_id: @flujo.id,
						nombre: aud_data[:nombre],
						plazo: aud_data[:plazo],
						con_certificacion: aud_data[:con_certificacion],
						con_validacion: aud_data[:con_validacion],
						final: aud_data[:final]
					})
					audits_ids << aud.id if aud.save
				end
				continua_flujo_segun_tipo_tarea
				format.js{ 
					flash[:success] = "Informe guardado correctamente"
					render js: "window.location='#{r_to}'"
				}
			else
				format.js{
					flash[:error] = "Se han detectado los siguientes errores:\n #{@informe.errors.full_messages.to_sentence}" 
					render js: "window.location='#{r_to}'"
				}
			end
		end
	end

	#DZC agrega al campo data de la tarea_pendiente 
	def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
		
		if @informe.nuevo
			@tarea_pendiente.pasar_a_siguiente_tarea 'A', {}, false
			@informe.update(nuevo: false)
		end
		@tarea_pendiente.pasar_a_siguiente_tarea 'D', {primera_ejecucion: true}, false
	end

	private
		def set_tarea_pendiente
			@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
			autorizado? @tarea_pendiente
			@tarea = @tarea_pendiente.tarea
	    @descargables = @tarea_pendiente.get_descargables
		end

		#DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
		def set_flujo
			@flujo = @tarea_pendiente.flujo
			@tipo_instrumento=@flujo.tipo_instrumento
			@manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
			@manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
			@proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
			@ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
		end

		def set_informe
			@informe=InformeAcuerdo.find_by(manifestacion_de_interes_id: @manifestacion_de_interes.id)
			@informe.calcula_fechas #DZC instancia las fechas de los plazos en variables no persistentes para su uso en la vista 
			if @informe.blank?
				@informe=InformeAcuerdo.create(manifestacion_de_interes_id: @manifestacion_de_interes.id, nuevo: true)
			end
			@auditorias = Auditoria.where(flujo_id: @flujo.id).all
			@comentarios =  @manifestacion_de_interes.blank? ? nil : @manifestacion_de_interes.comentarios_y_observaciones_termino_acuerdo
		end

		def set_manifestacion_de_interes
			actores_desde_tablas = MapaDeActor.construye_data_para_apl (@flujo)
	    @actores = (!MapaDeActor.adecua_actores_para_vista(actores_desde_tablas).blank? ? MapaDeActor.adecua_actores_para_vista(actores_desde_tablas) : [])#DZC se cambia la lectura de actores a la tabla 
	    @manifestacion_de_interes.accion_en_mapa_de_actores = :actualizacion
	    @manifestacion_de_interes.accion_en_set_metas_accion = :comite
	    @manifestacion_de_interes.temporal = true
	    @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
	    @set_metas_acciones_anexas = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id, true)
	    
	    @set_metas_accion = SetMetasAccion.new
	    if params[:tab_metas].present? # DZC 2018-11-05 12:37:11 permite focalizar la vista en la pestaña set metas y acciones
      	@tab_metas = params[:tab_metas]
    	end
	    unless @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank?
	      comentarios = @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.last
	      @actores_con_observaciones = comentarios[:actores_con_observaciones]
	    end
	    unless @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank?
	      comentarios = @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.last
	      @propuestas_con_observaciones = comentarios[:requiere_correcciones]
	    end
		end

		def informe_params
			params.require(:informe_acuerdo).permit(
				:con_extension,
				:plazo_maximo_adhesion, :plazo_finalizacion_implementacion,
				:plazo_maximo, :plazo_maximo_neto,
				:archivos_anexos_cache,
				archivos_anexos: [],
			)
		end

		def informe_archivos_anexos_posteriores_firma_params
			params.require(:informe_acuerdo).permit(
				:archivos_anexos_posteriores_firmas_cache,
				archivos_anexos_posteriores_firmas: []
			)
		end
end