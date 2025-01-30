class ComentariosController < ApplicationController
  before_action :authenticate_user!, except: [:modal_create,:reset]
  before_action :set_comentario, only: [:show,:read,:solved,:leido]

  def index
    if current_user.is_admin? || current_user.posee_rol_ascc?(Rol::JEFE_DE_LINEA) 
      @comentarios = Comentario.order(created_at: :desc).all
    else
      redirect_to root_path, alert: "No tiene permiso para acceder a esta vista"
    end
  end

  def show
    unless @comentario.leido
      @comentario.leido = true
      @comentario.save
    end
  end

  def new
    @comentario = Comentario.new
  end

  def reset
    respond_to do |format|
      format.js
    end
  end

  def modal_create
    __create_or_send("Comentario enviado correctamente")
  end

  def modal_response
    __response_or_send("Comentario enviado correctamente")
  end

  def create
    __create_or_send(t(:m_successfully_created, m: t(:comentario)))
  end

  def update
    respond_to do |format|
      if @comentario.update(comentario_params)
        format.js { flash.now[:success] = t(:m_successfully_updated, m: t(:comentario)) }
        format.html { redirect_to @comentario, notice: t(:m_successfully_updated, m: t(:comentario)) }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def read
    @comentario.leido = true
    @comentario.save
    redirect_to comentarios_url, notice: "Comentario fue marcado como leído"
  end

  def leido
    @comentario.update(leido: true)  # Marks the comment as read
    
    respond_to do |format|
      format.js { render 'comentarios/leido' }
    end
  end

  def solved
    @comentario.resuelto = true
    @comentario.leido = true
    @comentario.save
    redirect_to comentarios_url, notice: "Comentario fue marcado como resuelto"
  end

  private
    def set_comentario
      @comentario = Comentario.find(params[:id])
    end

    def comentario_params
      params.require(:comentario).permit(
        :tipo_comentario_id,
        :comentario,
        :email_contacto,
        :url_referencia,
        comentario_archivos_attributes: [ 
          :id, 
          :archivo,
          :archivo_cache,
          :_destroy
        ]
      )
    end

    def __create_or_send(success_message)
      @comentario = Comentario.new(comentario_params)
      @comentario.user_id = current_user.id unless current_user.nil?
      respond_to do |format|
        if @comentario.save
          ComentarioMailer.nuevo(@comentario).deliver_later
          @users = Responsable.__personas_responsables(Rol::REVISOR_COMENTARIOS, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)
          @users.each do |user|
            ComentarioMailer.nuevo_para_revisor(@comentario, user).deliver_later
          end
          format.js { 
            flash.now[:success] = success_message
            @comentario = Comentario.new
          }
          format.html { redirect_to @comentario, notice: success_message }

        else
          @error = true
          format.html { render :new }
          format.js
        end
      end
    end

    def __response_or_send(success_message)
      @comentario = Comentario.find(params[:comentario][:id])
        
      if params[:comentario][:requiere_envio_correo] == 'true'      
        @comentario.comentario = params[:comentario][:comentario]
        ComentarioMailer.respuesta(@comentario).deliver_later
      end
      #Actualiza estados
      @comentario_response = Comentario.find(params[:comentario][:id])
      @comentario_response.resuelto = true
      @comentario_response.leido = true
      @comentario_response.save
  
      respond_to do |format|
        format.js { render 'comentarios/modal_response' }
      end
    end
end
