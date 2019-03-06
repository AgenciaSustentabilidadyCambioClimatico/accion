class Admin::TiposContribuyentesController < ApplicationController
  before_action :authenticate_user!
	before_action :set_tipo_contribuyente, only: [:edit, :update, :destroy]

	def index
		@tipos_contribuyentes = TipoContribuyente.includes([:tipo_contribuyente]).order(id: :asc).all
	end

  def new
    @tipo_contribuyente = TipoContribuyente.new
  end

  def edit
  end

  def create
    @tipo_contribuyente = TipoContribuyente.new(tipo_contribuyente_params)
    respond_to do |format|
      if @tipo_contribuyente.save
        format.js { 
          flash.now[:success] = 'Tipo contribuyente correctamente creado'
          @tipo_contribuyente = TipoContribuyente.new
        }
        format.html { redirect_to edit_admin_actividades_economica_url(@actividad_economica), notice: 'Tipo contribuyente correctamente creado' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @tipo_contribuyente.update(tipo_contribuyente_params)
        format.js { flash.now[:success] = 'Tipo contribuyente correctamente actualizado.' }
        format.html { redirect_to edit_admin_tipos_contribuyente_url(@tipo_contribuyente), notice: 'Tipo contribuyente correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @tipo_contribuyente.destroy
    redirect_to admin_tipos_contribuyentes_url, notice: 'Tipo contribuyente correctamente eliminado.'
  end

  private
    def set_tipo_contribuyente
      @tipo_contribuyente = TipoContribuyente.find(params[:id])
    end

    def tipo_contribuyente_params
      params.require(:tipo_contribuyente).permit(
        :tipo_contribuyente_id,
        :nombre,
        :descripcion,
      )
    end
end