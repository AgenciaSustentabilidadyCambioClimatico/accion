class SeguimientoFpl::ReunionesController < ApplicationController
	before_action :authenticate_user!
	before_action :cargar_datos
	
	def new
		if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
			redirect_to root_path
		end
		@reunion = Reunion.new
	end

	def create
		@reunion = @proyecto.reuniones.new(reunion_params)
		respond_to do |format|
		  if @reunion.save

		  	params[:destinatarios].each do |dest|
					@reunion.reunion_destinatarios.create({
						destinatario_id: dest,
						visto: false
					})
				end

				@reunion.reunion_destinatarios.each do |rd|
					ReunionMailer.delay.enviar(rd)
				end

		  	@reunion.reunion_success @tarea_pendiente
		    format.html { redirect_to root_path, notice: "Reunion creada" }
        flash[:notice] = "Reunión creada"
				format.js { render js: "window.location.href='#{root_path}'" }
		  else
		    format.html { render :new , notice: "Error al crear reunión" }
        flash[:alert] = "Error al crear reunión"
		    format.js
		  end
		end
	end

	private

		def reunion_params
			params.require(:reunion).permit(
        :fecha,
        :direccion,
        :lat,
        :lng,
        :encabezado,
        :mensaje
    	)
	  end

	  def cargar_datos
    	@proyecto = Proyecto.find(params[:proyecto_id])
			@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente])
			autorizado? @tarea_pendiente
	  	tarea = @tarea_pendiente.tarea

			@destinatarios = [] #destinatarios vienen desde mapa de actores
			actores = MapaDeActor.includes(persona: :contribuyente).where(flujo_id: @tarea_pendiente.flujo_id).where("rol_id <> #{tarea.rol_id}").all
			actores.each do |actor|
				persona = actor.persona
				usuario = persona.user
				contribuyente = persona.contribuyente
				@destinatarios << {
					id: persona.id,
					nombre_completo: usuario.nombre_completo,
					rut: usuario.rut,
					institucion: contribuyente.razon_social,
					rut_institucion: contribuyente.rut_completo,
					rol: actor.rol.nombre
				}
			end

			@destinatarios = @destinatarios.group_by{|g| [g[:rut], g[:rut_institucion]]}.map{|rut, row| row[0].update(rol: row.map{|r| "<li>#{r[:rol]}</li>"}.join())}

			flujo_tareas = FlujoTarea.where(tarea_entrada_id: @tarea_pendiente.tarea_id).where(condicion_de_salida: 'B').first
			@encabezado = flujo_tareas.mensaje_salida_asunto #viene definido desde flujo tarea
			if @tarea_pendiente.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA
				@encabezado = "Modifica Reunión: #{@encabezado}"
			end
			@cuerpo_mensaje = flujo_tareas.mensaje_salida_cuerpo #viene definido desde la flujo tarea
	  end

end