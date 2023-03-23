require_relative '../../config/initializers/google_calendar.rb'
class ConvocatoriasController < ApplicationController
	protect_from_forgery with: :exception, unless: proc{action_name == 'reset_convocatoria'}
	before_action :authenticate_user!
	before_action :set_tarea_pendiente
	before_action :permiso_tarea
	before_action :set_flujo
	before_action :set_tipo
	before_action	:set_descargable_tareas
	before_action :set_convocatorias, only: [:index, :termina_etapa_negociacion]
	before_action :set_convocatoria, only: [:new, :create, :edit, :update, :destroy, :descargar_adjuntos]
	
	

	# # DELETE /convocatorias/
  def destroy
  	respond_to do |format|
  		url = tarea_pendiente_convocatorias_path(@tarea_pendiente)
  		convocatoria_id = @convocatoria.id
  		
	  	if @convocatoria.destroy
		  	# TareaPendiente.where(data: {convocatoria_id: @convocatoria.id}).update_all(estado_tarea_pendiente_id: 2)
		  	TareaPendiente.where("data ILIKE ?", "%:convocatoria_id: #{convocatoria_id}\n:convocatoria_tarea_pendiente%").destroy_all
		  	# TareaPendiente.where(data: {convocatoria_id: convocatoria_id, convocatoria_tarea_pendiente_id: @tarea_pendiente.id}).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)  	
	  		format.html { redirect_to url, flash: {warning: 'Convocatoria eliminada' } } # DZC 2018-10-11 15:04:36 se relimina el redireccionamiento
	  		format.js {
	    		flash.now[:success] = "Convocatoria eliminada" }
	    else
	    	format.html { redirect_to url, flash: {error: "No se pudo eliminar la convocatoria por los siguientes errores: #{@convocatoria.errors.messages.to_sentence}"} }
	    end
    end
  end
  # # GET /convocatorias/
  def show
  end

  # GET /convocatorias
  def index 
  end

	# GET /convocatoria/new
	def new
		
	end

	# POST /convocatorias
	def create
		#DZC TODO: cambiar creación nueva convocatoria para poder pasar el .nombre desde aqui
		# @convocatoria.new()
		# @convocatoria = Convocatoria.new(convocatoria_params.merge({flujo_id: @flujo.id, tarea_codigo: @tarea.codigo}))
		# @convocatoria.nombre = 'Convocar a comité coordinador' if @tarea.codigo == Tarea::COD_APL_030
		@convocatoria.assign_attributes(convocatoria_params)
		respond_to do |format|
		if @convocatoria.save
			#Generar Google meeting solo si hay destinatario
			if  @convocatoria.virtual? && params[:virtual_meeting]
				seleccionados = []
				params[:seleccionados].each do |id|
					persona = Persona.find(id)
					seleccionados << persona
				end

				service = GoogleCalendar.get_service
				meet = Google::Apis::CalendarV3::Event.new({
					summary: @convocatoria.nombre,
					start: {
						date_time: @convocatoria.fecha_hora.to_time.utc.iso8601,
						time_zone: 'America/Santiago'
					  },
					end: {
						date_time: (@convocatoria.fecha_hora.to_time + 2.hour).utc.strftime('%FT%T%:z'),
						time_zone: 'America/Santiago'
					},
					attendees: seleccionados.map { |seleccionado| { email: seleccionado[:email_institucional]} },
					conference_data: {
					  create_request: {
						conference_solution_key: {
						  type: 'hangoutsMeet'
						},
						request_id: SecureRandom.uuid
					  }
					}
				  })
				  result = service.insert_event("sistemaaccion@ascc.cl", meet, conference_data_version: 1, send_notifications: true)
				
					
				  @convocatoria.update(direccion: result.conference_data.entry_points[0].uri) if result.conference_data.present?
				  @convocatoria.update(mensaje_cuerpo: @convocatoria.mensaje_cuerpo + result.conference_data.entry_points[0].uri)

			end


				#crea minuta relacionada con esta convocatoria
				@tarea_pendiente.data = {convocatoria_id: @convocatoria.id} #DZC permite almacenar el id de la convocatoria
				@tarea_pendiente.save
				Minuta.create({
					convocatoria_id: @convocatoria.id,
					fecha_hora: @convocatoria.fecha_hora,
					tipo_reunion: @convocatoria.tipo_reunion,
					direccion: @convocatoria.direccion,
					lat: @convocatoria.lat,	
					lng: @convocatoria.lng
				})
		  	params[:seleccionados].uniq.each do |dest|
		  		#crea listado de convocados como destinatarios del correo
					@convocatoria.convocatoria_destinatarios.find_or_create_by(destinatario_id: dest)
				end
				@convocatoria.convocatoria_destinatarios.update_all(
					fecha_correo: DateTime.now,
					asistio: false)
				@convocatoria.convocatoria_destinatarios.each do |rd|
					rgc = RegistroAperturaCorreo.create(convocatoria_destinatario_id: rd.id, fecha_envio_correo: DateTime.now)
					# DZC 2018-10-04 19:44:58 se corrige error en el nombre de la variable rgc
					ConvocatoriaMailer.delay.enviar(rd, @convocatoria.mensaje_encabezado, @convocatoria.mensaje_cuerpo, @convocatoria.archivo_adjunto, rgc.id)
				end
				continua_flujo_segun_tipo_tarea
		  	format.html { redirect_to root_path, notice: "Convocatoria creada" }
				format.js { 
					flash[:success] = "Convocatoria creada"; render js: "window.location='#{tarea_pendiente_convocatorias_path}'" 
				}	
		  else
		    format.html { render :new,  notice: "Convocatoria NO creada" }
		    format.js {
		    	flash[:error] = "Convocatoria NO creada"
		    }
		  end
		end
	end

	# PATCH/PUT /convocatorias/edit
	def edit
	end

	# PATCH/PUT /convocatorias/edit, en ausencia de que el método edit esté definido
  def update
  	respond_to do |format|
			if @convocatoria.update(convocatoria_params) #DZC no es necesario el merge por que el value preexiste desde el create, pero se deja como ilustración
				#DZC actualiza los datos de la minuta
				@convocatoria.minuta.assign_attributes({
					fecha_hora: @convocatoria.fecha_hora,
					tipo_reunion: @convocatoria.tipo_reunion,
					direccion: @convocatoria.direccion,
					lat: @convocatoria.lat,
					lng: @convocatoria.lng
				})
				@convocatoria.minuta.save(validate: false)
				params[:seleccionados].uniq.each do |dest|
		  		#crea listado de convocados como destinatarios del correo
					@convocatoria.convocatoria_destinatarios.find_or_create_by(destinatario_id: dest)
				end
				@convocatoria.convocatoria_destinatarios.update_all(
					fecha_correo: DateTime.now,
					asistio: false)
				@convocatoria.convocatoria_destinatarios.each do |rd|
					rgc = RegistroAperturaCorreo.create(convocatoria_destinatario_id: rd.id, fecha_envio_correo: DateTime.now)
					# DZC 2018-10-04 19:44:58 se corrige error en el nombre de la variable rgc
					ConvocatoriaMailer.delay.enviar(rd, @convocatoria.mensaje_encabezado, @convocatoria.mensaje_cuerpo, @convocatoria.archivo_adjunto, rgc.id)
				end
				continua_flujo_segun_tipo_tarea
				format.html { redirect_to tarea_pendiente_convocatorias_path(@tarea_pendiente), notice: "Convocatoria modificada" }
				format.js { flash[:success] = "Convocatoria modificada"; render js: "window.location='#{tarea_pendiente_convocatorias_path}'" }
	    else
	    	format.html { render :edit, notice: "Convocatoria NO modificada" }
				format.js { 
					flash[:error] = "Convocatoria NO modificada"		
		  	}
	    end
	  end
  end

	#**descarga de archivos copiado desde rendicion_actividades_controler.descargar_tecnicas
	def descargar_adjuntos
		require 'zip'
		archivos = []
		archivos += @convocatoria.archivo_adjunto if !@convocatoria.archivo_adjunto.blank?
		if !@convocatoria.minuta.nil?
			archivos << @convocatoria.minuta.lista_asistencia if !@convocatoria.minuta.lista_asistencia.blank?
			archivos << @convocatoria.minuta.acta if !@convocatoria.minuta.acta.blank?
		end
    archivo_zip = Zip::OutputStream.write_buffer do |stream|
      archivos.each do |archivo|
        if archivo.is_a?(String)
          archivo_path = "#{Rails.root}/public#{archivo}"
          if File.exists?(archivo_path)
            split = archivo_path.split('/')
            nombre = split[split.length-1] # obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier
            # rename the file
            stream.put_next_entry(nombre)
            # add file to zip
            stream.write IO.read(archivo_path)
          end
        else
          if File.exists?(archivo.path)
            split = archivo.current_path.split('/') rescue archivo.path.split('/')# genera un array de palabras dentro del path
            nombre = split[split.length-1] # obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier
            # rename the file
            stream.put_next_entry(nombre)
            # add file to zip
            stream.write IO.read((archivo.current_path rescue archivo.path))
          end
        end
      end
    end
    archivo_zip.rewind
		send_data(archivo_zip.sysread, type: 'application/zip',filename: "archivos_adjuntos.zip")
	end

	#DZC REVISAR UTILIDAD
	# def termina_etapa_negociacion_comentarios
	# 	respond_to do |format|
	# 		if @convocatoria.update(manifestacion_params)
	# 			@manifestacion_de_interes.temporal = true
	# 			@manifestacion_de_interes.update({
	# 				comentarios_y_observaciones_negociacion_acuerdo: @convocatoria.comentarios,
	# 				fecha_termino_negociacion: Time.now.utc
	# 			})
	# 			@convocatoria.pasar_a_siguiente_tarea 'B'

	# 			# format.js { flash.now[:success] = "Etapa de negociación terminada"	; render js: "window.location='#{root_path}'"}
	#    		# format.html { redirect_to root_path, notice: "Etapa de negociación terminada" }
	#    	end
	# 	end
	# end

	#DZC agrega al campo data de la tarea_pendiente 
	def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
		case @tarea.codigo
		when Tarea::COD_APL_011
			@tarea_pendiente.pasar_a_siguiente_tarea 'A', {convocatoria_id: @convocatoria.id, convocatoria_tarea_pendiente_id: @tarea_pendiente.id}, false #DZC en espera que se carguen el acta o lista de asistencia en la minuta respectiva
		when Tarea::COD_APL_016
			@tarea_pendiente.pasar_a_siguiente_tarea 'A', {convocatoria_id: @convocatoria.id, convocatoria_tarea_pendiente_id: @tarea_pendiente.id}, false
		#DZC la tarea APL-021 se programó por separado en controlador actores_convocatorias
		when Tarea::COD_APL_030
			@tarea_pendiente.pasar_a_siguiente_tarea 'A', {convocatoria_id: @convocatoria.id, convocatoria_tarea_pendiente_id: @tarea_pendiente.id}, false #DZC en espera que se carguen el acta o lista de asistencia en la minuta respectiva
		when Tarea::COD_PPF_014
			@tarea_pendiente.pasar_a_siguiente_tarea 'B', {convocatoria_id: @convocatoria.id, convocatoria_tarea_pendiente_id: @tarea_pendiente.id}, false
	  end
	end

	private

	  def convocatoria_params
			parametros=params.require(:convocatoria).permit(
				:nombre,
        :fecha_hora,
        :tipo_reunion,
        :direccion,
        :lat,
        :lng,
        :mensaje_encabezado,
        :mensaje_cuerpo,
        :caracterizacion,
        archivo_adjunto: [], #permite agregar un hash de archivos
        archivo_adjunto_cache: []
    	)
      parametros
	  end

	  def convocatoria_destinatario_params
			params.require(:convocatoria_destinatario).permit(
      	:convocatoria_id,
        :destinatario_id,
        :fecha_correo,
        :asistio
      )
	  end

	  def manifestacion_params
	  	params.require(:convocatoria).permit(
	  		:comentarios
	  	)	
	  end 

		#asigna valor de id de tarea pendiente, leyendolo desde la URL (esto es neceario por que no se traspasa desde la jerarquia superior)
		def set_tarea_pendiente
			@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
			autorizado? @tarea_pendiente
			@tarea = @tarea_pendiente.tarea #crea una instancia de tarea a través de la forean key de tarea_pendiente (primary de tarea)
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

		def set_tipo
			@tipo=ConvocatoriaTipo.where(tarea_codigo: @tarea.codigo).first
		end

		def set_convocatorias
			#obtiene todas las concovatorias pertenecientes al flujo específico
	  	@convocatorias = Convocatoria.where(flujo_id: @flujo.id).where(tarea_codigo: @tarea.codigo).all
	  	@convocatoria = @convocatorias.blank? ? nil : @convocatorias.first
	  	@comentarios =  @manifestacion_de_interes.blank? ? nil : @manifestacion_de_interes.comentarios_y_observaciones_negociacion_acuerdo
	  	# @comentarios = @convocatoria.nil? ? nil : @convocatoria.comentarios
		end
				
		def set_convocatoria #asigna al objeto los valores correspondientes a los campos del registro que calza con el id obtenido como parámetro de la URL
			
			tipo_convocatoria_id = ConvocatoriaTipo.find_by(tarea_codigo: @tarea.codigo).blank? ? nil : ConvocatoriaTipo.find_by(tarea_codigo: @tarea.codigo).id
			#DZC se copia desde TAREA APL-021
			case action_name
			when "new", "create"
				@fecha_hora = Convocatoria.fecha_ultima_convocatoria(@flujo.id, @tarea.codigo).blank? ? DateTime.now.in_time_zone : Convocatoria.fecha_ultima_convocatoria(@flujo.id, @tarea.codigo)
				# DZC 2018-10-05 11:14:28 se elimina el agregar la dirección de la última convocatoria a la nueva
				@convocatoria = Convocatoria.new(flujo_id: @flujo.id, fecha_hora: @fecha_hora, tipo: tipo_convocatoria_id, tarea_codigo: @tarea.codigo)
			when "edit", "update", "destroy", "descargar_adjuntos"
				@convocatoria = Convocatoria.find(params[:id])
			end
			@convocatoria.accion = action_name
			@convocatoria.establece_mensaje_encabezado
			@convocatoria.establece_mensaje_cuerpo
			@destinatarios = @convocatoria.destinatarios

		end

		def set_descargable_tareas 
			@descargable_tareas = DescargableTarea.where(tarea_id: @tarea.id).order(id: :asc).all
		end

		def permiso_tarea
      unless @tarea_pendiente.tengo_permiso? current_user
        flash[:warning] = 'No tiene permiso para acceder a esta tarea'
        redirect_to root_path
      end
    end
end
