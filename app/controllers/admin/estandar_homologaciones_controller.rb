class Admin::EstandarHomologacionesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_estandar, only: [ :edit, :update, :destroy, :get_estandar]
  def index
    @estandares = EstandarHomologacion.all
  end

  def new
    @estandar = EstandarHomologacion.new
    @estandar.estandar_set_metas_acciones.build
  end

  def edit
  	render :new
  end

  def create
    params = estandar_params.to_hash
    if !params["estandar_set_metas_acciones_attributes"].blank?
      params["estandar_set_metas_acciones_attributes"].each do |esma|
        nivel_id = esma.last["obligatorio_para_nivel"]
        if !nivel_id.blank?
          obligatorio_para_nivel = params["estandar_niveles_attributes"][nivel_id]["numero"]
          #reescribo valor
          params["estandar_set_metas_acciones_attributes"][esma.first]["obligatorio_para_nivel"] = obligatorio_para_nivel
        end
      end
    end
    @estandar = EstandarHomologacion.new(params)
    respond_to do |format|
      if @estandar.save
      	@estandar = EstandarHomologacion.new()
        @estandar.estandar_set_metas_acciones.build
      	format.js { flash.now[:success] = 'Estandar de certificación correctamente creado.'}
        format.html { redirect_to admin_estandar_homologaciones_path, notice: 'Estandar de certificación correctamente creado.' }
      else
        mensaje = "Error al crear."
        mensaje = @estandar.errors[:base].first if @estandar.errors.key?(:base)
        format.html { render :new }
        format.js { flash[:error] = mensaje }
      end
    end
  end

  def update
    params = estandar_params.to_hash
    if !params["estandar_set_metas_acciones_attributes"].blank?
      params["estandar_set_metas_acciones_attributes"].each do |esma|
        nivel_id = esma.last["obligatorio_para_nivel"]
        if !nivel_id.blank?
          obligatorio_para_nivel = params["estandar_niveles_attributes"].select{|f,l| l["id"].to_s == nivel_id.to_s}.values.first["numero"]
          #reescribo valor
          params["estandar_set_metas_acciones_attributes"][esma.first]["obligatorio_para_nivel"] = obligatorio_para_nivel
        end
      end
    end
    respond_to do |format|
      if @estandar.update(params)
      	format.js { flash[:success] = 'Estandar de certificación correctamente actualizado'}
        format.html { redirect_to edit_admin_estandar_homologacion_path(@estandar), notice: 'Estandar de certificación correctamente actualizado' }
      else
        format.html { render :new }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def destroy
    begin
      @estandar.destroy
      respond_to do |format|
        format.html { redirect_to admin_estandar_homologaciones_path, notice: 'Estandar de certificación correctamente eliminado.' }
        format.json { head :no_content }
      end
    rescue
      respond_to do |format|
        format.html { redirect_to admin_estandar_homologaciones_path, alert: 'Estandar de certificación no puede ser eliminado ya que se encuentra en uso.' }
        format.json { head :no_content }
      end
    rescue
    end
  end

  def get_estandar
  	
  end

  private

    def set_estandar
    	if params[:id].present?
      	@estandar = EstandarHomologacion.find(params[:id])
      end
    end

    def estandar_params
      params.require(:estandar_homologacion).permit(
        :nombre,
        :descripcion,
        :url_referencia,
        referencias: [],
        estandar_niveles_attributes: [
          :id,
          :numero,
          :nombre,
          :porcentaje,
          :archivo,
          :_destroy
        ],
        estandar_set_metas_acciones_attributes: [
          :id, 
          :accion_id, 
          :materia_sustancia_id, 
          :meta_id, 
          :alcance_id, 
          :criterio_inclusion_exclusion, 
          :descripcion_accion, 
          :detalle_medio_verificacion,
          :puntaje,
          :obligatorio_para_nivel,
          :estandar_nivel_id,
          :_destroy
        ]
      )
    end
end

