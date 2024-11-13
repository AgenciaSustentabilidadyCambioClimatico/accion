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
    #Obtiene las lineas para el seguimiento del FPL Línea 1.1 - Implementación de APL
    @lineas_fpl_1_1 = TipoInstrumento.where(id: [TipoInstrumento::FPL_LINEA_1_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO])
    @fondo_produccion_limpia_1_1_ids = FondoProduccionLimpia.where(flujo_apl_id: params["apl_id"]).pluck(:flujo_id)
    @flujos_con_tipo_instrumento_1_1 = Flujo.where(id: @fondo_produccion_limpia_1_1_ids, tipo_instrumento_id: [TipoInstrumento::FPL_LINEA_1_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO])
    
    @instrumento_seleccionado_1_1 = []
    if @flujos_con_tipo_instrumento_1_1.present?
      @instrumento_seleccionado_1_1 = Flujo.where(id: @flujos_con_tipo_instrumento_1_1).pluck(:tipo_instrumento_id)
    end
   
    #Obtiene las lineas para el seguimiento del FPL Línea 1.2.1 - Implementación de APL
    @lineas_fpl_1_2_1 = TipoInstrumento.where(id: [TipoInstrumento::FPL_LINEA_1_2_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO])
    @fondo_produccion_limpia_1_2_1_ids = FondoProduccionLimpia.where(flujo_apl_id: params["apl_id"]).pluck(:flujo_id)
    @flujos_con_tipo_instrumento_1_2_1 = Flujo.where(id: @fondo_produccion_limpia_1_2_1_ids, tipo_instrumento_id: [TipoInstrumento::FPL_LINEA_1_2_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO])
    
    @instrumento_seleccionado_1_2_1 = []
    if @flujos_con_tipo_instrumento_1_2_1.present?
      @instrumento_seleccionado_1_2_1 = Flujo.where(id: @flujos_con_tipo_instrumento_1_2_1).pluck(:tipo_instrumento_id)
    end

    #Obtiene las lineas para el seguimiento del FPL Línea 1.2.2 - Implementación de APL
    @lineas_fpl_1_2_2 = TipoInstrumento.where(id: [TipoInstrumento::FPL_LINEA_1_2_2, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2])
    @fondo_produccion_limpia_1_2_2_ids = FondoProduccionLimpia.where(flujo_apl_id: params["apl_id"]).pluck(:flujo_id)
    @flujos_con_tipo_instrumento_1_2_2 = Flujo.where(id: @fondo_produccion_limpia_1_2_2_ids, tipo_instrumento_id: [TipoInstrumento::FPL_LINEA_1_2_2, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2])
    
    @instrumento_seleccionado_1_2_2 = []
    if @flujos_con_tipo_instrumento_1_2_2.present?
      @instrumento_seleccionado_1_2_2 = Flujo.where(id: @flujos_con_tipo_instrumento_1_2_2).pluck(:tipo_instrumento_id)
    end

    ##Obtiene las lineas para el seguimiento del FPL Línea 1.3 - Certificación de APL
    @lineas_fpl_1_3 = TipoInstrumento.where(id: [TipoInstrumento::FPL_LINEA_1_3,TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION])
    @fondo_produccion_limpia_1_3_ids = FondoProduccionLimpia.where(flujo_apl_id: params["apl_id"]).pluck(:flujo_id)
    @flujos_con_tipo_instrumento_1_3 = Flujo.where(id: @fondo_produccion_limpia_1_3_ids, tipo_instrumento_id: [TipoInstrumento::FPL_LINEA_1_3,TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION])
  
    @instrumento_seleccionado_1_3 = []
    if @flujos_con_tipo_instrumento_1_3.present?
      @instrumento_seleccionado_1_3 = Flujo.where(id: @flujos_con_tipo_instrumento_1_3).pluck(:tipo_instrumento_id) 
    end

    # Responder con un fragmento HTML que renderice el nuevo select
    respond_to do |format|
      format.js
    end
  end

  def create
    #obtengo el user_id del postulante de la manifestacion de interes
    tarea_fondo = Tarea.find_by_codigo(Tarea::COD_APL_001)
    postulante = TareaPendiente.find_by(tarea_id: tarea_fondo.id, flujo_id: params[:apl])

    contribuyente_id = Flujo.find_by(id: params[:apl]).contribuyente_id

    tipo_instrumento_id =  params[:flujo][:tipo_instrumento_id] # params[:tipo_instrumento_id]
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
      respond_to do |format|
        format.js { flash.now[:success] = msj; render js: "window.location='#{root_path}'" }
        format.html { redirect_to root_path, flash: { notice: msj } }
      end
    end
  end

  private
    def send_message(tarea, user)
      u = User.find(user)
      mensajes = FondoProduccionLimpiaMensaje.where(tarea_id: tarea.id)
      mensajes.each do |mensaje|
        FondoProduccionLimpiaMailer.paso_de_tarea(mensaje.asunto, mensaje.body, u).deliver_now
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
end