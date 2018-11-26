class Admin::ActividadesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_actividad, only: [:show, :edit, :update, :destroy]

  def index
    @actividades = Actividad.order(id: :desc).all
    @actividad  = Actividad.new
  end

  def new
    @actividad = Actividad.new
  end

  def edit
  end

  def create
    @actividad = Actividad.new(actividad_params)
    respond_to do |format|
      if @actividad.save
        format.js { 
          flash.now[:success] = 'Actividad correctamente creada.'
          @actividad = Actividad.new
        }
        format.html { redirect_to edit_admin_actividad_url(@actividad), notice: 'Actividad correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @actividad.update(actividad_params)
        format.js { flash.now[:success] = 'Actividad correctamente actualizada.' }
        format.html { redirect_to edit_admin_actividad_url(@actividad), notice: 'Actividad correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @actividad.destroy
    redirect_to admin_actividades_url, notice: 'Actividad correctamente eliminada.'
  end

  private
    def set_actividad
      @actividad = Actividad.find(params[:id])
    end

    def actividad_params
      params.require(:actividad).permit(
        :nombre,
        :descripcion
      )
    end
end