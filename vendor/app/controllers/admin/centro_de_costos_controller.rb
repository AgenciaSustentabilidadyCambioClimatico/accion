class Admin::CentroDeCostosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_centro_de_costo, only: [:show, :edit, :update, :destroy]

  def index
    @centro_de_costos = CentroDeCosto.order(id: :desc).all
    @centro_de_costo  = CentroDeCosto.new
  end

  def new
    @centro_de_costo = CentroDeCosto.new
  end

  def edit
  end

  def create
    @centro_de_costo = CentroDeCosto.new(centro_de_costo_params)
    respond_to do |format|
      if @centro_de_costo.save
        format.js { 
          flash.now[:success] = 'Centro de costo correctamente creado.'
          @centro_de_costo = CentroDeCosto.new
        }
        format.html { redirect_to edit_admin_centro_de_costo_url(@centro_de_costo), notice: 'Centro de costo correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @centro_de_costo.update(centro_de_costo_params)
        format.js { flash.now[:success] = 'Centro de costo correctamente actualizada.' }
        format.html { redirect_to edit_admin_centro_de_costo_url(@centro_de_costo), notice: 'Centro de costo correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @centro_de_costo.destroy
    redirect_to admin_centro_de_costos_url, notice: 'Centro de costo correctamente eliminado.'
  end

  private
    def set_centro_de_costo
      @centro_de_costo = CentroDeCosto.find(params[:id])
    end

    def centro_de_costo_params
      params.require(:centro_de_costo).permit(
        :nombre,
        :descripcion,
        :ano_asignacion,
        :monto_asignacion
      )
    end
end