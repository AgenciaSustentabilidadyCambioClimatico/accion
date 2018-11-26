class Admin::TipoAportesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tipo_aporte, only: [:show, :edit, :update, :destroy]

  def index
    @tipo_aportes = TipoAporte.order(id: :desc).all
    @tipo_aporte  = TipoAporte.new
  end

  def new
    @tipo_aporte = TipoAporte.new
  end

  def edit
  end

  def create
    @tipo_aporte = TipoAporte.new(tipo_aporte_params)
    respond_to do |format|
      if @tipo_aporte.save
        format.js { 
          flash.now[:success] = 'Tipo aporte correctamente creado.'
          @tipo_aporte = TipoAporte.new
        }
        format.html { redirect_to edit_admin_tipo_aporte_url(@tipo_aporte), notice: 'Tipo aporte correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @tipo_aporte.update(tipo_aporte_params)
        format.js { flash.now[:success] = 'Tipo aporte correctamente actualizada.' }
        format.html { redirect_to edit_admin_tipo_aporte_url(@tipo_aporte), notice: 'Tipo aporte correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @tipo_aporte.destroy
    redirect_to admin_tipo_aportes_url, notice: 'Tipo aporte correctamente eliminado.'
  end

  private
    def set_tipo_aporte
      @tipo_aporte = TipoAporte.find(params[:id])
    end

    def tipo_aporte_params
      params.require(:tipo_aporte).permit(
        :nombre,
        :descripcion
      )
    end
end