class Admin::ResponsablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_responsable, only: [:show, :edit, :update, :destroy]
  before_action :set_new_contribuyente, only: [:new, :edit, :create, :update]

  def index
    @responsables = Responsable.order(id: :desc).all
    @responsable  = Responsable.new
    # DZC 2018-10-23 09:55:04 TODO: revisar algoritomo de toma de datos sobre contribuyente
  end

  def new
    @responsable  = Responsable.new
  end

  def edit
  end

  def create
    @responsable = Responsable.new(responsable_params)
    respond_to do |format|
      if @responsable.save
        format.js { 
          flash[:success] = 'Responsable correctamente creado.'
          @responsable = Responsable.new
        }
        format.html { redirect_to edit_admin_responsable_url(@responsable), notice: 'Responsable correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      # 
      if @responsable.update(responsable_params)
        format.js { flash.now[:success] = 'Responsable correctamente actualizado.' }
        format.html { redirect_to edit_admin_responsable_url(@responsable), notice: 'Responsable correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @responsable.destroy
    redirect_to admin_responsables_url, notice: 'Responsable correctamente eliminado.'
  end

  private
    def set_responsable
      @responsable = Responsable.find(params[:id])
    end

    def set_new_contribuyente
      @contribuyente    = Contribuyente.new
      @contribuyentes  = []
    end

    def responsable_params
      params.require(:responsable).permit(
      	:tipo_instrumento_id,
        :rol_id,
        :cargo_id,
        :contribuyente_id,
        :actividad_economica_id,
        :tipo_contribuyente_id
      )
    end
end