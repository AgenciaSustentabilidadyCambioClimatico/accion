class Admin::ReporteSustentabilidadController < ApplicationController
  before_action :authenticate_user!
  before_action :soy_admin?
  before_action :set_reporte_sustentabilidad

  def edit
  end

  def update
    respond_to do |format|
      if @reporte_sustentabilidad.update(reporte_sustentabilidad_params)
        format.js { flash.now[:success] = 'Reporte sustentabilidad correctamente actualizado' }
        format.html { redirect_to admin_edit_datos_publico_path(), notice: 'Reporte sustentabilidad correctamente actualizado' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  private

    def set_reporte_sustentabilidad
      @reporte_sustentabilidad = ReporteSustentabilidad.all.first
      @reporte_sustentabilidad = ReporteSustentabilidad.new if @reporte_sustentabilidad.nil?
    end

    def reporte_sustentabilidad_params
      params.require(:reporte_sustentabilidad).permit(
        :titulo_intro,
        :cuerpo_intro
      )
    end

    def soy_admin?
      unless current_user.is_admin?
        flash[:warning] = 'No tiene permiso para acceder a esta página'
        redirect_to root_path
      end
    end
end