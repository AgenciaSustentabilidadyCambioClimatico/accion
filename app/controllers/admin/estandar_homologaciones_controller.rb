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
    @estandar = EstandarHomologacion.new(estandar_params)
    respond_to do |format|
      if @estandar.save
      	@estandar = EstandarHomologacion.new()
      	format.js { flash.now[:success] = 'Estandar de homologacion correctamente creado.'}
        format.html { redirect_to admin_estandar_homologaciones_path, notice: 'Estandar de homologacion correctamente creado.' }
      else
        format.html { render :new }
        format.js { flash[:error] = "Error al crear." }
      end
    end
  end

  def update
    respond_to do |format|
      if @estandar.update(estandar_params)
      	format.js { flash[:success] = 'Estandar de homologacion correctamente actualizado'}
        format.html { redirect_to edit_admin_estandar_homologacion_path(@estandar), notice: 'Estandar de homologacion correctamente actualizado' }
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def destroy
    @estandar.destroy
    respond_to do |format|
      format.html { redirect_to admin_estandar_homologaciones_path, notice: 'Estandar de homologación correctamente eliminado.' }
      format.json { head :no_content }
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
      params.require(:estandar_homologacion).permit(:nombre, {referencias: []},estandar_set_metas_acciones_attributes: [:id, :accion_id, :materia_sustancia_id, :meta_id, :alcance_id, :criterio_inclusion_exclusion, :descripcion_accion, :detalle_medio_verificacion, :_destroy])
    end
end

