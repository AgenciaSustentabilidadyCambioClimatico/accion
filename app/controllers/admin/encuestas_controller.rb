class Admin::EncuestasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_preguntas_base
  before_action :set_encuesta, only: [:edit, :update, :destroy, :responder, :guardar]
  # before_action :set_tarea_pendiente, only: [:responder, :guardar]
  

  def index
    @encuestas = Encuesta.includes([:encuesta_preguntas]).order(id: :desc).all
    @encuesta  = Encuesta.new
    
  end

  def new
    if @preguntas_base.size > 0
      @encuesta = Encuesta.new(@encuesta_params_base)
      #link_to=edit_admin_encuesta_url(@encuesta)
    else
      @encuesta = Encuesta.new
    end
  end

  def edit
    @encuesta.filtrar_nested_attributes
  end

  def create
    @encuesta = Encuesta.new(encuesta_params)
    respond_to do |format|
      if @encuesta.save
        format.js { 
          flash.now[:success] = 'Encuesta correctamente creada.'
          @encuesta = Encuesta.new
        }
        format.html { redirect_to edit_admin_encuesta_url(@encuesta), notice: 'Encuesta correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @encuesta.update(encuesta_params)
        format.js { flash.now[:success] = 'Encuesta correctamente actualizada.' }
        format.html { redirect_to edit_admin_encuesta_url(@encuesta), notice: 'Encuesta correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def volver_nueva
      @encuesta.destroy
  end

  def destroy
    @encuesta.destroy
    redirect_to admin_encuestas_url, notice: 'Encuesta correctamente eliminada.'
  end
  
  def responder
    # 
    if @tarea_pendiente.blank? || @tarea_pendiente.user_id != current_user.id || @tarea_pendiente.no_esta_pendiente?
      encuesta_no_encontrada
    else
      #DZC se determina si la encuesta fue correctamente llenada
      
      @desactivado = (EncuestaUserRespuesta.where(flujo_id: @flujo.id, encuesta_id: @encuesta.id, user_id: current_user.id, tarea_pendiente_id: @tarea_pendiente.id).size >= @encuesta.encuesta_preguntas.where(obligatorio: true).size)
      @encuesta_user_respuesta = EncuestaUserRespuesta.new
    end
  end
  
  def guardar #DZC se agrega el flujo_id
     
    @guardado = false
    parametros = params.require(:encuesta_user_respuesta).permit(preguntas_y_respuestas: {})
    parametros[:encuesta_id] = @encuesta.id
    parametros[:flujo_id] = @flujo.id
    parametros[:tarea_pendiente_id] = @tarea_pendiente.id
    #DZC agrega a la encuesta la institución del proveedor (responsable de entregables del flujo actual)
    proveedor = MapaDeActor.where(flujo_id: @flujo.id, rol_id: Rol::RESPONSABLE_ENTREGABLES).includes([flujo: [:contribuyente]]).first
    @encuesta_user_respuesta = EncuestaUserRespuesta.new(parametros)
    respond_to do |format|
      unless @encuesta_user_respuesta.tiene_errores? || proveedor.blank?
        
        if @encuesta_user_respuesta.cerrar(current_user.id, @flujo.id, proveedor.persona.contribuyente.id, @tarea_pendiente.id) # DZC 2018-10-22 15:29:43 se corrige el contribuyente por el del responsable entregable como actor del mapa de actores
          data = @tarea_pendiente.data
          data[:encuesta_completada] = true
          @tarea_pendiente.data = data
          # DZC 2018-10-22 15:05:53 se modifica estado de tareas PPF-023 y PPF-024
          if [Tarea::COD_PPF_023, Tarea::COD_PPF_024].include? (@tarea.codigo)
            @tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
          end
          @guardado = @tarea_pendiente.save
          if @guardado
            flash[:success] = 'Encuesta correctamente guardada.'
            format.js {
              @desactivado = true #DZC 2018-11-02 18:33:01 se agrega para que no se pueda modificar los valores de la encuesta, si ha sido respondida y enviada.
              if params[:encuesta_user_respuesta][:externo] == "false"
                render js: "window.location='#{root_url}'"
              end
            }
          end
        end
      end
      format.js
    end
  end

  private

    def set_tarea_pendiente #DZC setea objetos relativos a la tarea pendiente y al flujo
      @tarea_pendiente=nil
      @flujo=nil
      if params[:tarea_pendiente_id].present?
        @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
        autorizado? @tarea_pendiente
        @tarea = @tarea_pendiente.blank? ? nil : @tarea_pendiente.tarea
        @flujo = @tarea_pendiente.flujo
      end
      if !@flujo.nil?
        @tipo_instrumento=@flujo.tipo_instrumento
        @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
        @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
        @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
        @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
      end
    end

    def set_preguntas_base
      @preguntas_base= Pregunta.where(base: true).order(id: :asc).all
      encuesta_preguntas=[]
      orden=0
      @preguntas_base.map do |pb|
        encuesta_preguntas << {:pregunta_id => pb.id, :orden => orden, obligatorio: true}
        orden+=1
      end
      @encuesta_params_base = {titulo: "",valor_tiempo_para_contestar: "25",unidad_tiempo_para_contestar: "days", encuesta_preguntas_attributes: encuesta_preguntas}
    end

    def set_encuesta
      # 
      if @flujo.nil?
        begin
          @encuesta = Encuesta.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          encuesta_no_encontrada
        end
      else
        @encuesta = Encuesta.find(params[:encuesta_id])
      end
    end

    def encuesta_no_encontrada
      warning = 'No se encontró la encuesta solicitada'
      redirect_to root_path, flash: { warning: warning }
    end

    def encuesta_params
      params.require(:encuesta).permit(
        :titulo,
        :valor_tiempo_para_contestar,
        :unidad_tiempo_para_contestar,
        :solo_dias_habiles,
        encuesta_preguntas_attributes: [
          :id,
          :orden,
          :obligatorio,
          :pregunta_id,
          :_destroy,
        ]
      )
    end
end