class Admin::FondoProduccionLimpiaMensajesController < ApplicationController
    include ApplicationHelper
    before_action :set_fondo_produccion_limpia_mensaje, only: %i[show edit update destroy]
  
    def index
      @fondo_produccion_limpia_mensaje = FondoProduccionLimpiaMensaje.all
    end
  
    def show; end
  
    def new
      @fondo_produccion_limpia_mensaje = FondoProduccionLimpiaMensaje.new
    end
  
    def create
        @fondo_produccion_limpia_mensaje = FondoProduccionLimpiaMensaje.new(fondo_produccion_limpia_mensaje_params)

        respond_to do |format|
            if @fondo_produccion_limpia_mensaje.save
            format.js {
                render js: "window.location='#{admin_fondo_produccion_limpia_mensajes_path}'"
                flash[:success] = 'Mensaje Creado correctamente'
            }
            else
            format.html { render :new }
            format.js
            end
        end
    end
    
    def edit; end
  
    def update
      respond_to do |format|
        if @fondo_produccion_limpia_mensaje.update(fondo_produccion_limpia_mensaje_params)
          format.js {
            render js: "window.location='#{admin_fondo_produccion_limpia_mensajes_path}'"
            flash[:success] = 'Mensaje actualizado correctamente'
          }
        else
          format.html { render :edit }
          format.js
        end
      end
    end
  
    def destroy
    end
  
    private
  
    def fondo_produccion_limpia_mensaje_params
        params.require(:fondo_produccion_limpia_mensaje).permit(:asunto, :body, :tarea_id)
    end
  
    def set_fondo_produccion_limpia_mensaje
      @fondo_produccion_limpia_mensaje = FondoProduccionLimpiaMensaje.find(params[:id])
    end
end
