class Admin::ClasificacionesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_clasificacion, only: [:show, :edit, :update, :destroy]

  def index
    @clasificaciones = Clasificacion.order(id: :desc).all
    @clasificacion  = Clasificacion.new
  end

  def new
    @clasificacion = Clasificacion.new
  end

  def edit
  end

  def create
    @clasificacion = Clasificacion.new(clasificacion_params)
    respond_to do |format|
      if @clasificacion.save
        format.js { 
          flash.now[:success] = 'Clasificación correctamente creada.'
          @clasificacion = Clasificacion.new
        }
        format.html { redirect_to edit_admin_clasificacion_url(@clasificacion), notice: 'Clasificación correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @clasificacion.update(clasificacion_params)
        format.js { flash.now[:success] = 'Clasificación correctamente actualizada.' }
        format.html { redirect_to edit_admin_clasificacion_url(@clasificacion), notice: 'Clasificación correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @clasificacion.destroy
    redirect_to admin_clasificaciones_url, notice: 'Clasificación correctamente eliminada.'
  end

  private
    def set_clasificacion
      @clasificacion = Clasificacion.find(params[:id])
    end

    def clasificacion_params
      params.require(:clasificacion).permit(
        :clasificacion_id,
        :nombre,
        :descripcion,
        :referencia,
        :es_meta,
        :imagen,
        :icono,
        :color
      )
    end
end