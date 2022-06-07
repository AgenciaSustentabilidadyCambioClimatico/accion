class Admin::ActividadesEconomicasController < ApplicationController
  before_action :authenticate_user!
	before_action :set_actividad_economica, only: [:edit, :update, :destroy]

	def index
		@actividades_economicas = ActividadEconomica.where.not(codigo_ciiuv4: nil).order(id: :asc).all
	end

  def new
    @actividad_economica = ActividadEconomica.new
  end

  def edit
  end

  def create
    @actividad_economica = ActividadEconomica.new(actividad_economica_params)
    respond_to do |format|
      if @actividad_economica.save
        format.js { 
          flash.now[:success] = 'Actividad económica correctamente creada'
          @actividad_economica = ActividadEconomica.new
        }
        format.html { redirect_to edit_admin_actividades_economica_url(@actividad_economica), notice: 'Actividad económica correctamente creada' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
  	respond_to do |format|
	    if @actividad_economica.update(actividad_economica_params)
        format.js { flash.now[:success] = 'Actividad económica correctamente actualizada' }
	      format.html { redirect_to edit_admin_actividades_economica_url(@actividad_economica), notice: 'Actividad económica correctamente actualizada' }
	    else
	    	format.html { render :edit }
        format.js
	    end
    end
  end

  def destroy
    @actividad_economica.destroy
    redirect_to admin_actividades_economicas_url, notice: 'Actividad económica correctamente eliminada.'
  end

  private
    def set_actividad_economica
      @actividad_economica = ActividadEconomica.find(params[:id])
    end

    def actividad_economica_params
      params.require(:actividad_economica).permit(
      	:codigo_ciiuv2,
      	:descripcion,
      	:descripcion_ciiuv2,
      	:codigo_ciiuv4,
      	:descripcion_ciiuv4,
      )
    end
end