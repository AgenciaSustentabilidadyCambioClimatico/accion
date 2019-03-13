class Admin::FlujoTareasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_flujo_tarea, only: [:edit, :update, :destroy]
  before_action :set_metodos

  def index
    @flujo_tareas = FlujoTarea.includes([:tarea_entrada,:tarea_salida]).order(id: :desc).all
    @flujo_tarea  = FlujoTarea.new
  end

  def new
    @flujo_tarea = FlujoTarea.new
  end

  def edit
  end

  def create
    @flujo_tarea = FlujoTarea.new(flujo_tarea_params)
    if flujo_tarea_params[:sin_salida].to_i == 1
      @flujo_tarea.tarea_salida_id = nil
    end
    respond_to do |format|
      if @flujo_tarea.save
        format.js { 
          flash.now[:success] = 'Flujo tarea correctamente creado.'
          @flujo_tarea = FlujoTarea.new
        }
        format.html { redirect_to edit_admin_flujo_tarea_url(@flujo_tarea), notice: 'Flujo tarea correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    @flujo_tarea.attributes = flujo_tarea_params
    if flujo_tarea_params[:sin_salida].to_i == 1
      @flujo_tarea.tarea_salida_id = nil
    end
    respond_to do |format|
      if @flujo_tarea.save
        format.js { flash.now[:success] = 'Flujo tarea correctamente actualizada.' }
        format.html { redirect_to edit_admin_flujo_tarea_url(@flujo_tarea), notice: 'Flujo tarea correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @flujo_tarea.destroy
    redirect_to admin_flujo_tareas_url, notice: 'Flujo tarea correctamente eliminado.'
  end

  private
    def set_metodos
      @metodos = FlujoTarea.metodos(current_user)
    end

    def set_flujo_tarea
      @flujo_tarea = FlujoTarea.find(params[:id])
    end

    def flujo_tarea_params
      params.require(:flujo_tarea).permit(
        :etapa_id,
        :tarea_entrada_id,
        :sin_salida,
        :tarea_salida_id,
        :descripcion_flujo,
        :condicion_de_salida,
        :mensaje_salida_asunto,
        :mensaje_salida_cuerpo,
        rol_destinatarios: []
      )
    end
end