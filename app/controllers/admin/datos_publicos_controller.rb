class Admin::DatosPublicosController < ApplicationController
  before_action :authenticate_user!
  before_action :soy_admin?
  before_action :set_datos_publicos

  def edit
  end

  def update
    respond_to do |format|
      if @datos_publicos.update(datos_publicos_params)
        format.js { flash.now[:success] = 'Datos públicos correctamente actualizados' }
        format.html { redirect_to admin_edit_datos_publico_path(), notice: 'Datos públicos correctamente actualizados' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  private

    def set_datos_publicos
      #id 1 porque solo sera un registro que contenga la data
      @datos_publicos = DatosPublico.load
    end

    def datos_publicos_params
      params.require(:datos_publico).permit(
        :extension_reporte,
        visibilidad_documentos: [],
        visibilidad_empresas_adheridas: [],
        visibilidad_empresas_certificadas: []
      )
    end

    def soy_admin?
      unless current_user.is_admin?
        flash[:warning] = 'No tiene permiso para acceder a esta página'
        redirect_to root_path
      end
    end
end