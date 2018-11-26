class Admin::ActividadesPorLineasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_actividad_por_linea, only: [:show, :edit, :update, :destroy]

  def index
    @actividades_por_lineas = ActividadPorLinea.order(id: :desc).all
    @actividad_por_linea  = ActividadPorLinea.new
  end

  def new
    @actividad_por_linea = ActividadPorLinea.new
  end

  def edit
  end

  def create
    @actividad_por_linea = ActividadPorLinea.new(actividad_por_linea_params)
    respond_to do |format|
      if @actividad_por_linea.save
        format.js { 
          flash.now[:success] = 'Actividad por línea correctamente creada.'
          @actividad_por_linea = ActividadPorLinea.new
        }
        format.html { redirect_to edit_admin_actividades_por_linea_url(@actividad_por_linea), notice: 'Actividad por línea correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @actividad_por_linea.update(actividad_por_linea_params)
        format.js { flash.now[:success] = 'Actividad por línea correctamente actualizada.' }
        format.html { redirect_to edit_admin_actividades_por_linea_url(@actividad_por_linea), notice: 'Actividad por línea correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @actividad_por_linea.destroy
    redirect_to admin_actividades_por_lineas_url, notice: 'Actividad por línea correctamente eliminada.'
  end

  private
    def set_actividad_por_linea
      @actividad_por_linea = ActividadPorLinea.find(params[:id])
    end

    def actividad_por_linea_params
      params.require(:actividad_por_linea).permit(
        :actividad_id,
        :tipo_instrumento_id,
        :tipo_permiso
      )
    end
end