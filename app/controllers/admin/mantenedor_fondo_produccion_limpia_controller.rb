class Admin::MantenedorFondoProduccionLimpiaController < ApplicationController
  before_action :authenticate_user!

  def index
    @flujo = Flujo.new
    @fondo_produccion_limpia = FondoProduccionLimpia.new

    personas = current_user.personas
    personas_id = personas.pluck(:id)
    user_actores = MapaDeActor.where(persona_id: personas.pluck(:id))

    if current_user.is_admin? || current_user.is_ascc?
      @instrumentos = Flujo.order(id: :desc)
    else
      @instrumentos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq).order(id: :desc)
    end
    @apls = @instrumentos.where.not(manifestacion_de_interes_id: nil)
  
  end

  def cargar_lineas

    @flujo = Flujo.new
    @flujos = Flujo.find_by(id: params[:apl_id].to_i)

    if @flujos != nil
      postulante = MapaDeActor.where(flujo_id: @flujos.id,rol_id: Rol::PROPONENTE).first
      @flujo.user_id = postulante.persona.user_id
      @flujo.nombre_completo = postulante.persona.user.nombre_completo
    else
      @flujo.user_id = ''
      @flujo.nombre_completo = ''
    end 

    # Configuración de líneas y sus respectivos tipo_instrumento_id
    lineas_config = [
      { linea: '1_1', tipos: [TipoInstrumento::FPL_LINEA_1_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO] },
      { linea: '1_2_1', tipos: [TipoInstrumento::FPL_LINEA_1_2_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO] },
      { linea: '1_2_2', tipos: [TipoInstrumento::FPL_LINEA_1_2_2, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2] },
      { linea: '1_3', tipos: [TipoInstrumento::FPL_LINEA_1_3, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION] }
    ]
  
    # Recorrer cada línea y obtener la información
    lineas_config.each do |config|
      tipo_ids = config[:tipos]
      linea_id = "lineas_fpl_#{config[:linea]}"
      flujo_id = "fondo_produccion_limpia_#{config[:linea]}_ids"
      flujo_instrumento_id = "flujos_con_tipo_instrumento_#{config[:linea]}"
      instrumento_seleccionado_id = "instrumento_seleccionado_#{config[:linea]}"
  
      # Obtener las lineas
      instance_variable_set("@#{linea_id}", TipoInstrumento.where(id: tipo_ids))
  
      # Obtener los ids de FondoProduccionLimpia
      instance_variable_set("@#{flujo_id}", FondoProduccionLimpia.where(flujo_apl_id: params["apl_id"]).pluck(:flujo_id))
  
      # Obtener los flujos con tipo_instrumento_id
      instance_variable_set("@#{flujo_instrumento_id}", Flujo.where(id: instance_variable_get("@#{flujo_id}"), tipo_instrumento_id: tipo_ids))
  
      # Obtener los instrumentos seleccionados
      selected_instrumento_ids = instance_variable_get("@#{flujo_instrumento_id}").pluck(:tipo_instrumento_id)
      instance_variable_set("@#{instrumento_seleccionado_id}", selected_instrumento_ids)
    end
  
    # Verificar la existencia de las tareas
    @existe_apl_005 = tarea_existente?(Tarea::COD_APL_005)
    @existe_apl_022 = tarea_existente?(Tarea::COD_APL_022)
    @existe_apl_023 = tarea_existente?(Tarea::COD_APL_023)
  
    # Responder con un fragmento HTML que renderice el nuevo select
    respond_to do |format|
      format.js
    end
  end

  def create
    postulante = Persona.where(user_id: params[:user_id]).first
    msj = ''

    if postulante != nil
      contribuyente_id = Flujo.find_by(id: params[:apl]).contribuyente_id
      tipo_instrumento_id = params[:tipo_instrumento_id]
  
      flujo = Flujo.new(contribuyente_id: contribuyente_id, tipo_instrumento_id: tipo_instrumento_id)
  
      if flujo.save
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_00)
        flujo.tarea_pendientes.create(
          tarea_id: tarea_fondo.id,
          estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
          user_id: postulante.user_id,
          data: {}
        )
  
        send_message(tarea_fondo, postulante.user_id)
  
        codigo_proyecto = determine_codigo_proyecto(flujo.tipo_instrumento_id)
  
        fpl = FondoProduccionLimpia.create(
          flujo_id: flujo.id,
          flujo_apl_id: params[:apl],
          codigo_proyecto: codigo_proyecto
        )
  
        flujo.update(fondo_produccion_limpia_id: fpl.id)
  
        msj = 'Flujo fondo de producción limpia creado correctamente.'
        flash[:success] = msj
      else
        msj = 'No se pudo guardar el flujo.'
        flash[:error] = msj
      end
    else
      msj = 'Hubo un error al obtener el usuario.'
      flash[:error] = msj
    end
  
    respond_to do |format|
      format.js { }
      format.html { redirect_to admin_mantenedor_fondo_produccion_limpia_path, flash: { notice: msj } }
    end
  end

  private

    def send_message(tarea, user)
      u = User.find(user)
      mensajes = FondoProduccionLimpiaMensaje.where(tarea_id: tarea.id)
      mensajes.each do |mensaje|
        FondoProduccionLimpiaMailer.paso_de_tarea(mensaje.asunto, mensaje.body, u).deliver_later
      end
    end

    def determine_codigo_proyecto(tipo_instrumento_id)
      case tipo_instrumento_id
      when TipoInstrumento::FPL_LINEA_1_1, TipoInstrumento::FPL_LINEA_5_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
        "Proyecto DyAPL"
      when TipoInstrumento::FPL_LINEA_1_2_1, TipoInstrumento::FPL_LINEA_1_2_2, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
        "Proyecto SyC"
      when TipoInstrumento::FPL_LINEA_1_3, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        "Proyecto EdC"
      else
        "Unknown"
      end
    end

    # Método para verificar la existencia de una tarea
    def tarea_existente?(codigo)
      tarea = Tarea.find_by_codigo(codigo)
      TareaPendiente.exists?(tarea_id: tarea.id, flujo_id: params["apl_id"])
    end
  
end
