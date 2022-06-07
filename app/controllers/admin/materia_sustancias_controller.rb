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

    #como no se en cuantas partes se usa evalaure la caida

    respond_to do |format|
      begin
        
        @materia_sustancia.destroy
        format.js { flash.now[:success] = 'Materia/Sustancia correctamente eliminada.'  }
        format.html { redirect_to admin_materia_sustancias_url, notice: 'Materia/Sustancia correctamente eliminada.' }
      rescue
        format.html { redirect_to admin_materia_sustancias_url, alert: 'Materia/Sustancia no puede ser eliminada ya que está siendo ocupada en un Acuerdo.' }
        format.js { flash.now[:alert] = 'Materia/Sustancia no puede ser eliminada ya que está siendo ocupada en un Acuerdo.'  }
      end
    end
  end

  private
    def set_materia_sustancia
      @materia_sustancia = MateriaSustancia.find(params[:id])
    end

    def materia_sustancia_params
      params.require(:materia_sustancia).permit(
        :unidad_base,
        :nombre,
        :descripcion,
        :posee_una_magnitud_fisica_asociada,
        materia_sustancia_clasificaciones_attributes: [
          :id,
          :clasificacion_id,
          :_destroy
        ],
        materia_sustancia_metas_attributes: [
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