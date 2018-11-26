class Admin::AlcancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_alcance, only: [:show, :edit, :update, :destroy]

  def index
    @alcances = Alcance.order(id: :desc).all
    @alcance  = Alcance.new
  end

  def new
    @alcance = Alcance.new
  end

  def edit
  end

  def create
    @alcance = Alcance.new(alcance_params)
    respond_to do |format|
      if @alcance.save
        format.js { 
          flash.now[:success] = 'Alcance correctamente creado.'
          @alcance = Alcance.new
        }
        format.html { redirect_to edit_admin_alcance_url(@alcance), notice: 'Alcance correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @alcance.update(alcance_params)
        format.js { flash.now[:success] = 'Alcance correctamente actualizada.' }
        format.html { redirect_to edit_admin_alcance_url(@alcance), notice: 'Alcance correctamente actualizado.' }
      else
        # DZC 2018-10-26 11:46:30 se agregó validación de modificación de nombres en alcances no editables
        texto = "No se puede modificar el nombre de los alcances #{@alcance.no_editables.to_sentence}."
        format.html { render :edit, flash: {error: texto} }
        format.js {
          flash.now[:error] = texto
        }
      end
    end
  end

  def destroy
    # DZC 2018-10-26 11:47:04 se modificó para evitar eliminación de alcances no editables
    if @alcance.es_editable? 
      @alcance.destroy
      redirect_to admin_alcances_url, notice: 'Alcance correctamente eliminado.'
    else
      redirect_to admin_alcances_url, flash: {error:"No se pueden eliminar los alcances #{@alcance.no_editables.to_sentence}."}
    end
  end

  private
    def set_alcance
      @alcance = Alcance.find(params[:id])
      @alcance.nombre_anterior = @alcance.nombre #DZC 2018-10-26 11:31:04 se agrega para mantener copia del nombre anterior
    end

    def alcance_params
      params.require(:alcance).permit(
        :nombre,
        :descripcion
      )
    end
end