class Admin::MateriaSustanciasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_materia_sustancia, only: [:show, :edit, :update, :destroy]
  before_action :set_unidades, only: [:new, :edit, :create, :update]

  def index
    @materia_sustancias = MateriaSustancia.order(id: :desc).all
    @materia_sustancia  = MateriaSustancia.new
  end

  def new
    @materia_sustancia = MateriaSustancia.new
  end

  def edit
  end

  def create
    @materia_sustancia = MateriaSustancia.new(materia_sustancia_params)
    respond_to do |format|
      if @materia_sustancia.save
        format.js { 
          flash.now[:success] = 'Materia/Sustancia correctamente creada.'
          @materia_sustancia = MateriaSustancia.new
        }
        format.html { redirect_to edit_admin_materia_sustancia_url(@materia_sustancia), notice: 'Materia/Sustancia correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @materia_sustancia.update(materia_sustancia_params)
        format.js { flash.now[:success] = 'Materia/Sustancia correctamente actualizada.' }
        format.html { redirect_to edit_admin_materia_sustancia_url(@materia_sustancia), notice: 'Materia/Sustancia correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @materia_sustancia.destroy
    redirect_to admin_materia_sustancias_url, notice: 'Materia/Sustancia correctamente eliminada.'
  end

  private
    def set_materia_sustancia
      @materia_sustancia = MateriaSustancia.find(params[:id])
    end

    def materia_sustancia_params
      params.require(:materia_sustancia).permit(
        :meta_id,
        :unidad_base,
        :nombre,
        :descripcion,
        :posee_una_magnitud_fisica_asociada,
        materia_sustancia_clasificaciones_attributes: [
          :id,
          :clasificacion_id,
          :_destroy
        ]
      )
    end

    def set_unidades
      @unidades = Unit.definitions.values
      @unidades.reject! { |k| k.prefix?}
      @unidades = @unidades.map{|k| [k.name.gsub(/[<>]/, '').upcase, k.display_name] }      
    end
end