class Admin::CuencasController < ApplicationController
  before_action :authenticate_user!
  before_action :soy_admin?
  before_action :set_cuenca, only: [:edit, :update]

  def index
    @cuencas = Cuenca.order(id: :asc).all
  end

  def new
    @cuenca = Cuenca.new
  end

  def edit
  end

  def create
    @cuenca = Cuenca.new(cuenca_params)
    respond_to do |format|
      if @cuenca.save
        format.js { 
          flash.now[:success] = 'Cuenca correctamente creada'
          @cuenca = Cuenca.new
        }
        format.html { redirect_to edit_admin_cuenca_url(@cuenca), notice: 'Cuenca correctamente creada' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @cuenca.update(cuenca_params)
        format.js { flash.now[:success] = 'Cuenca correctamente actualizada' }
        format.html { redirect_to admin_cuencas_url(@cuenca), notice: 'Cuenca correctamente actualizada' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  private

    def set_cuenca
      @cuenca = Cuenca.find(params[:id])
    end

    def cuenca_params
      params.require(:cuenca).permit(
        :id,
        :nombre_cuenca,
        :codigo_cuenca,
        :region
      )
    end

    def soy_admin?
      unless current_user.is_admin?
        flash[:warning] = 'No tiene permiso para acceder a esta tarea'
        redirect_to root_path
      end
    end
end