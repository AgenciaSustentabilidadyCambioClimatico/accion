class DocumentoDiagnosticosController < ApplicationController
	before_action :authenticate_user!, except: [:descarga_estandar_acuerdo_informe]
	before_action :set_tarea_pendiente, except: [:descarga, :descarga_estandar_acuerdo_informe]
	before_action :set_manifestacion_de_interes, except: [:descarga_estandar_acuerdo_informe]
	before_action :set_documento_diagnostico, only: [:actualizacion,:actualizar,:revision,:enviar_revision]

	def actualizacion
		@comentarios = @manifestacion_de_interes.comentarios_diagnostico_ordenados
		@manifestacion_de_interes.setear_documento_diagnosticos
	end

	def actualizar
		success = nil
    respond_to do |format|
      if @manifestacion_de_interes.update(documento_diagnostico_params)
      	success = 'Documentos de diagnóstico correctamente actualizados.'
      	continua_flujo_segun_tipo_tarea #DZC agregamos la tarea pendiente para el revisor
      end
      format.js {
      		@comentarios = @manifestacion_de_interes.comentarios_diagnostico_ordenados
        	flash.now[:success] = success 
        	flash.now[:error] = @manifestacion_de_interes.errors.messages # DZC 2018-10-09 21:24:19 se agrega información de los errores
        }
    end
	end

	def revision
		@comentarios = @manifestacion_de_interes.comentarios_diagnostico_ordenados
		@manifestacion_de_interes.setear_documento_diagnosticos
		@manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos = nil
	end

	def enviar_revision
		respond_to do |format|
			parameters = enviar_revision_documento_diagnostico_params()
			@manifestacion_de_interes.aprueba_documentos_diagnostico = parameters[:aprueba_documentos_diagnostico]
			# (1) Se asume que la primera vez, no habrá comentarios de este tipo, si los hay guardamos los comentarios anteriores
			# y dejamos la variable con el valor que viene del formulario (sólo string)
			comentarios_anteriores = @manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos.blank? ? [] : @manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos
			@manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos = parameters[:comentarios_y_observaciones_documento_diagnosticos]
			if @manifestacion_de_interes.valid?
				# (2) creamos un comentario de tipo array, para agregar más información
				comentarios_anteriores << {
					datetime: DateTime.now,
					# user: current_user.nombre_completo(),
					user: current_user.nombre_completo,
					texto: @manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos
				}
				# (3) antes de guardar, volvemos a dejar la variable como un array

				@manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos = comentarios_anteriores

				@manifestacion_de_interes.tarea_codigo=@tarea.codigo
				@manifestacion_de_interes.save

				@manifestacion_de_interes.update(enviar_revision_update_documento_diagnostico_params)

				continua_flujo_segun_tipo_tarea #DZC agregamos nuevamente la tarea pendiente para el revisado 
				format.js {
					@comentarios = @manifestacion_de_interes.comentarios_diagnostico_ordenados
					# (4) finalmente dejamos la variable en nulo para no mostrarla en el formulario
					@manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos = nil
					flash.now[:success] = "Documentos diagnóstico correctamente actualizados"
				}
			else
				format.js {
					flash.now[:error] = @manifestacion_de_interes.errors.messages
					# @manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos = nil
					# render js: "window.location='#{curent_path}'" 			
				}
			end
		end
	end

	def continua_flujo_segun_tipo_tarea #DZC generalización de condiciones de continuación de flujo
		case @tarea.codigo
		when Tarea::COD_APL_013
			@tarea_pendiente.update(data: {}) if @tarea_pendiente.primera_ejecucion
			@tarea_pendiente.pasar_a_siguiente_tarea 'A',{},false
		when Tarea::COD_APL_014
			@tarea_pendiente.pasar_a_siguiente_tarea 'B',{},false
		end
	end


	def descarga_estandar_acuerdo_informe
		estandar = params['estandar_id'].present? ? params['estandar_id'].to_i : nil
		acuerdo_antiguo = params['acuerdo_id'].present? ? params['acuerdo_id'].to_i : nil
		informe_impacto = params['informe_id'].present? ? params['informe_id'].to_i : nil
		if acuerdo_antiguo.present?
			mia = ManifestacionDeInteres.find(acuerdo_antiguo)
			archivos = []
			mia.documento_diagnosticos.each do |doc|
				archivos << doc.archivo
			end
			zip = helpers.generar_zip archivos
			send_data(zip, type: 'application/zip',filename: "documentos_diagnostico.zip")
		end
		if estandar.present?
			estandar = EstandarHomologacion.find(estandar)
			archivos = estandar.referencias
			zip = helpers.generar_zip archivos
			send_data(zip, type: 'application/zip',filename: "documentos_estandar.zip")
		end
		if informe_impacto.present?
			informe = InformeImpacto.find(informe_impacto)
			archivos = []
			archivos << informe.documento
			zip = helpers.generar_zip archivos
			send_data(zip, type: 'application/zip',filename: "documentos_informe_impacto.zip")
		end
	end

	def descarga
		acuerdo_antiguo = @manifestacion_de_interes.diagnostico_id
		estandar = @manifestacion_de_interes.estandar_de_certificacion_id
		if acuerdo_antiguo.present?
			mia = ManifestacionDeInteres.find(acuerdo_antiguo)
			archivos = []
			mia.documento_diagnosticos.each do |doc|
				archivos << doc.archivo
			end
			zip = helpers.generar_zip archivos
			send_data(zip, type: 'application/zip',filename: "documentos_diagnostico.zip")
		end
		if estandar.present?
			estandar = EstandarHomologacion.find(estandar)
			archivos = estandar.referencias
			zip = helpers.generar_zip archivos
			send_data(zip, type: 'application/zip',filename: "documentos_diagnostico.zip")
		end
	end

	private
	def set_tarea_pendiente
		@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
		autorizado? @tarea_pendiente
		@tarea = @tarea_pendiente.tarea
	end

	def set_manifestacion_de_interes
		@manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
		@manifestacion_de_interes.tarea_codigo = @tarea.codigo
	end

	def set_documento_diagnostico
		if action_name.to_sym == :actualizacion ||action_name.to_sym == :actualizar
			accion = :actualizacion
		elsif action_name.to_sym == :revision ||action_name.to_sym == :enviar_revision
			accion = :revision
		end

		@manifestacion_de_interes.accion_en_documento_diagnostico = accion
		@manifestacion_de_interes.temporal = true

	end

	def documento_diagnostico_params
		params.require(:manifestacion_de_interes).permit(
			documento_diagnosticos_attributes: [
				:id,
				:tipo_documento_diagnostico_id,
				:nombre,
				:publico,
				:archivo,
				:archivo_cache,
				:_destroy,
				:estandar_id,
				:acuerdo_id,
				:informe_id
			]
		)
	end

	def enviar_revision_documento_diagnostico_params
		params.require(:manifestacion_de_interes).permit(
			:aprueba_documentos_diagnostico,
			:comentarios_y_observaciones_documento_diagnosticos,
			documento_diagnosticos_attributes: [
				:id,
				:requiere_correcciones
			]
		)
	end

	def enviar_revision_update_documento_diagnostico_params
		params.require(:manifestacion_de_interes).permit(
			documento_diagnosticos_attributes: [
				:id,
				:requiere_correcciones
			]
		)
	end
end
