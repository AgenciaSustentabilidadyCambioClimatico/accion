class Admin::TipoDocumentoDiagnosticosController < ApplicationController
  before_action :authenticate_user!
  before_action :tengo_permiso
  before_action :set_tipo_documento_diagnostico, only: [:edit, :update, :destroy]

  def index
    @tipo_documento_diagnosticos = TipoDocumentoDiagnostico.all
  end

  def new
    @tipo_documento_diagnostico = TipoDocumentoDiagnostico.new
  end

  def create
    @tipo_documento_diagnostico = TipoDocumentoDiagnostico.new(tipo_documento_diagnostico_params)
    respond_to do |format|
      if @tipo_documento_diagnostico.save
        format.js { 
          flash.now[:success] = t(:m_successfully_created, m: t(:tipo_documento_diagnostico))
          @tipo_documento_diagnostico = TipoDocumentoDiagnostico.new
        }
        format.html { redirect_to admin_tipo_documento_diagnostico_url, notice: t(:m_successfully_created, m: t(:tipo_documento_diagnostico)) }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @tipo_documento_diagnostico.update(tipo_documento_diagnostico_params)
        format.js { flash.now[:success] = t(:m_successfully_updated, m: t(:tipo_documento_diagnostico)) }
        format.html { redirect_to admin_tipo_documento_diagnostico_url, notice: t(:m_successfully_updated, m: t(:tipo_documento_diagnostico)) }
      else
        format.html { render :edit }
        format.js
      end
    end
  end


  def destroy
    error = notice = nil
    cannot_destroy_permission = (DocumentoDiagnostico.where(tipo_documento_diagnostico: @tipo_documento_diagnostico.id).all.size > 0)
    respond_to do |format|
      unless cannot_destroy_permission
        @tipo_documento_diagnostico.destroy
        notice = t(:m_successfully_destroyed, m: t(:tipo_documento_diagnostico))
      else
        error = t(:este_modelo_no_se_puede_eliminar_porque_está_siendo_utilizado_por, m:t(:tipo_documento_diagnostico).downcase, p: t(:documentos_diagnostico).downcase)
      end

      format.html { redirect_to admin_tipo_documento_diagnosticos_url, flash: { error: error, notice: notice }  }
      format.json { head :no_content }
    end
  end

  private
    def tipo_documento_diagnostico_params
      params.require(:tipo_documento_diagnostico).permit(:nombre, :descripcion)
    end

    def set_tipo_documento_diagnostico
      @tipo_documento_diagnostico = TipoDocumentoDiagnostico.find(params[:id])
    end

    def tengo_permiso
      unless current_user.is_admin?
        flash[:warning] = 'Usted no tiene permiso para manejar los tipo documento diagnóstico'
        redirect_to root_path
      end
    end
end
