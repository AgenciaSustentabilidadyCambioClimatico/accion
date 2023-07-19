class Admin::RegistroProveedorMensajesController < ApplicationController
  include ApplicationHelper
  before_action :set_registro_proveedor_mensaje, only: %i[show edit update destroy]

  def index
    @registro_proveedor_mensajes = RegistroProveedorMensaje.all
  end

  def show; end

  def new
    @registro_proveedor_mensaje = RegistroProveedorMensaje.new
  end

  def create
    @registro_proveedor_mensaje = RegistroProveedorMensaje.new(registro_proveedor_mensaje_params)
    respond_to do |format|
      if @registro_proveedor_mensaje.save
        format.js {
          render js: "window.location='#{admin_registro_proveedor_mensajes_path}'"
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
      if @registro_proveedor_mensaje.update(registro_proveedor_mensaje_params)
        format.js {
          render js: "window.location='#{admin_registro_proveedor_mensajes_path}'"
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

  def registro_proveedor_mensaje_params
    params.require(:registro_proveedor_mensaje).permit(:asunto, :body, :tarea_id)
  end

  def set_registro_proveedor_mensaje
    @registro_proveedor_mensaje = RegistroProveedorMensaje.find(params[:id])
  end
end
