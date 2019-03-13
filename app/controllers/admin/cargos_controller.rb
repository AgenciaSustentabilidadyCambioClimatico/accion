class Admin::CargosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cargo, only: [:edit, :update, :destroy]

  def index
    @cargos = Cargo.where('id <> ?', Cargo::ROOT).order(id: :asc).all
  end

  def new
    @cargo = Cargo.new
  end

  def edit
  end

  def create
    @cargo = Cargo.new(cargo_params)
    respond_to do |format|
      if @cargo.save
        format.js { 
          flash.now[:success] = t(:m_successfully_created, m: t(:cargo))
          @cargo = Cargo.new
        }
        format.html { redirect_to admin_cargos_url, notice: t(:m_successfully_created, m: t(:cargo)) }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @cargo.update(cargo_params)
        format.js { flash.now[:success] = t(:m_successfully_updated, m: t(:cargo)) }
        format.html { redirect_to admin_cargos_url, notice: t(:m_successfully_updated, m: t(:cargo)) }
      else
        format.html { render :edit }
        format.js
      end
    end
  end


  def destroy
    error = notice = nil
    cannot_destroy_permission = (PersonaCargo.where(cargo_id: @cargo.id).all.size > 0)
    respond_to do |format|
      unless cannot_destroy_permission
        @cargo.destroy
        notice = t(:m_successfully_destroyed, m: t(:cargo))
      else
        error = t(:este_modelo_no_se_puede_eliminar_porque_está_siendo_utilizado_por, m:t(:cargo).downcase, p: t(:users).downcase)
      end

      format.html { redirect_to admin_cargos_url, flash: { error: error, notice: notice }  }
      format.json { head :no_content }
    end
  end


  private
    def set_cargo
      @cargo = Cargo.find(params[:id])
    end
    def cargo_params
      params.require(:cargo).permit(:nombre, :descripcion)
    end
end
