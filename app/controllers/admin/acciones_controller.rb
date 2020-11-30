class Admin::AccionesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_accion, only: [:show, :edit, :update, :destroy]

  def index
    
    @acciones = Accion.order(id: :desc).all
    @accion  = Accion.new
  end

  def new
    @accion = Accion.new
  end

  def edit
  end

  def create
    @accion = Accion.new(accion_params)
    respond_to do |format|
      if @accion.save
        format.js { 
          flash.now[:success] = 'Acción correctamente creada.'
          @accion = Accion.new
        }
        format.html { redirect_to edit_admin_accion_url(@accion), notice: 'Acción correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @accion.update(accion_params)
        format.js { flash.now[:success] = 'Acción correctamente actualizada.' }
        format.html { redirect_to edit_admin_accion_url(@accion), notice: 'Acción correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    #redirect_to admin_acciones_url, notice: 'Acción correctamente eliminada.'
    #como no se en cuantas partes se usa evalaure la caida

    respond_to do |format|
      begin
        @accion.destroy
        format.js { flash.now[:success] = 'Acción correctamente eliminada.'  }
        format.html { redirect_to admin_acciones_url, notice: 'Acción correctamente eliminada.' }
      rescue
        format.html { redirect_to admin_acciones_url, alert: 'Accion no puede ser eliminada ya que está siendo ocupada en un Acuerdo.' }
        format.js { flash.now[:alert] = 'Accion no puede ser eliminada ya que está siendo ocupada en un Acuerdo.'  }
      end
    end
  end

  private
    def set_accion
      @accion = Accion.find(params[:id])
    end

    def accion_params
      params.require(:accion).permit(
        :nombre,
        :descripcion,
        :debe_asociar_materia_sustancia,
        :meta_id,
        :medio_de_verificacion_generico,
        accion_clasificaciones_attributes: [
          :id,
          :clasificacion_id,
          :_destroy
        ],
        accion_relacionadas_attributes: [
          :id,
          :accion_relacionada_id,
          :descripcion,
          :_destroy
        ]
      )
    end
end