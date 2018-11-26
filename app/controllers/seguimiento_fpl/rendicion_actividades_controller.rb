class SeguimientoFpl::RendicionActividadesController < ApplicationController
	before_action :authenticate_user!
	before_action :carga_proyecto
	before_action :set_actividad_item, only: [:update, :descargar_tecnicas, :descargar_respaldos, :descargar]

	def index
		redirect_to root_path if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
		@tipo_rendicion = :envio

		mod_calendario = ModificacionCalendario.find_by(proyecto_id: @proyecto.id)
		unless mod_calendario.nil?
			mod_calendario.atributos_proyecto_actividades.each do |pa|
				pa[:actividad_item_attributes].each do |ai|
					@en_modificacion <<ai[:proyecto_actividad_id] if ai[:modificado] == true
				end
			end
		else
			@en_modificacion = []
		end
		@en_modificacion = @en_modificacion.uniq

	end

	def rendicion_tecnica
		redirect_to root_path if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
		@tipo_rendicion = :tecnica
		@estado_rendiciones = EstadoRendicion.to_select(:nombre,:id,EstadoRendicion.where(id: [3,4]))
	end

	def rendicion_contable
		redirect_to root_path if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
		@tipo_rendicion = :contable		
		@estado_rendiciones = EstadoRendicion.to_select(:nombre,:id,EstadoRendicion.where(id: [3,4]))
	end

	def update
		# item = ActividadItem.includes(:proyecto_actividad).find(params[:id])
		respond_to do |format|
			parametros = item_params
			if @item.update(parametros)
				# cambio de estados no va aquí el aceptar y demas
				# fix, cambia estado de la revision contraparte
				if @tarea_pendiente.tarea.codigo == Tarea::COD_FPL_011
					@item.estado_tecnica_id = 2 if parametros[:estado_tecnica_id].blank? && !parametros[:archivos_tecnica].blank?
					@item.estado_respaldo_id = 2 if parametros[:estado_respaldo_id].blank? && !parametros[:archivos_respaldo].blank?
				end
				# defino que sea hoy la fecha_ultima_rendicion
				@item.fecha_ultima_rendicion = Time.now
				@item.save
				# actualizo la fecha solo si viene, casos de revisiones no viene
				unless parametros[:fecha_realizacion_compromiso].blank?
					@item.proyecto_actividad.fecha_realizacion_compromiso = parametros[:fecha_realizacion_compromiso] 
					@item.proyecto_actividad.save
				end

				@proyecto = Proyecto.find(params[:proyecto_id])
				#@item.item_success @tarea_pendiente, @proyecto.actividades_listas

				condicion = nil
				if @tarea_pendiente.tarea.codigo == Tarea::COD_FPL_011
					condicion = 'A'
				elsif @tarea_pendiente.tarea.codigo == Tarea::COD_FPL_012
					if @item.estado_tecnica_id == 3 #Aceptada
						condiciones = 'A'
					elsif @item.estado_tecnica_id == 4 #Observada
						condiciones = 'B'
					end
				elsif @tarea_pendiente.tarea.codigo == Tarea::COD_FPL_013 
					if @item.estado_respaldo_id == 4 #Observada
						condiciones = 'B'
					else
						condiciones = 'A'
					end
				end
				@tarea_pendiente.pasar_a_siguiente_tarea(condiciones,{}, false)

				ruta_para_redireccion = parametros[:estado_tecnica_id].blank? ? (parametros[:estado_respaldo_id].blank? ? seguimiento_fpl_proyecto_rendicion_actividades_path(@tarea_pendiente, @proyecto) : seguimiento_fpl_proyecto_rendicion_actividad_rendicion_contable_path(@tarea_pendiente, @proyecto) ) : seguimiento_fpl_proyecto_rendicion_actividad_rendicion_tecnica_path(@tarea_pendiente, @proyecto)
				mensaje = "Actividades actualizadas"
				ModificacionCalendario.bloquear_actividades_e_items(@proyecto.id, @item.proyecto_actividad.id, @item)
				if @proyecto.actividades_listas
					tareas = [Tarea::ID_FPL_003,Tarea::ID_FPL_004,Tarea::ID_FPL_009,Tarea::ID_FPL_010,Tarea::ID_FPL_011,Tarea::ID_FPL_012,
						Tarea::ID_FPL_013,Tarea::ID_FPL_015,Tarea::ID_FPL_016,Tarea::ID_FPL_017,Tarea::ID_FPL_018]
					TareaPendiente.where(flujo_id: tarea_pendiente.flujo_id)
												.where(tarea_id: tareas)
												.update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)
					@tarea_pendiente.pasar_a_siguiente_tarea('C',{encuesta_id: ft.tarea_salida.encuesta_id})
					ruta_para_redireccion = root_path
					mensaje = "Actividades listas"
				end
      	format.html { redirect_to ruta_para_redireccion, notice: mensaje }
      else
      	mensaje = ""
      	@item.errors.messages.each do |k,v|
      		mensaje = mensaje + "<br>#{k.to_s.humanize}: #{v[0]}"
      	end
      	format.html { redirect_to seguimiento_fpl_proyecto_rendicion_actividades_path(@tarea_pendiente, @proyecto), alert: "Error al subir archivos #{mensaje}" }
      	format.js {}
      end
    end
	end
	def descargar
		archivo = params[:tipo] == "tecnica" ? "archivos_tecnica" : "archivos_respaldo"
		nombre_archivo = archivo == "archivos_respaldo" ? "archivos_respaldo_contable" : archivo
		send_data(generar_zip(@item.send(archivo)), type: 'application/zip',filename: "#{nombre_archivo}.zip")		
	end
	def descargar_tecnicas
		# item = ActividadItem.find(params[:id])
		send_data(generar_zip(@item.archivos_tecnica), type: 'application/zip',filename: "archivos_tecnica.zip")
	end

	def descargar_respaldos
		# item = ActividadItem.find(params[:id])
		send_data(generar_zip(@item.archivos_respaldo), type: 'application/zip',filename: "archivos_respaldo_contable.zip")
	end

	private 
		def item_params
      params.require(:actividad_item).permit(
      	{archivos_tecnica: []},
      	{archivos_respaldo: []},
      	:estado_tecnica_id,
      	:estado_respaldo_id,
      	:observacion_tecnica,
      	:observacion_respaldo,
      	:fecha_realizacion_compromiso
      )
    end

		def carga_proyecto
			@proyecto = Proyecto.includes(:proyecto_actividad, :rendiciones).find(params[:proyecto_id])
			@glosas = Glosa.all
			@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente])
			autorizado? @tarea_pendiente

			@en_modificacion = []
		end

		def set_actividad_item
			@item = ActividadItem.includes(:proyecto_actividad).find(params[:id])
		end

		def generar_zip archivos
			require 'zip'
			file = Zip::OutputStream.write_buffer do |stream|
				archivos.each_with_index do |archivo_tecnica|
					split = archivo_tecnica.current_path.split('/')
					nombre = split[split.length-1]
					# rename the file
					stream.put_next_entry(nombre)
					# add file to zip
					stream.write IO.read(archivo_tecnica.current_path)
				end  
	   	end
	   	file.rewind
	   	file.sysread
		end

end 