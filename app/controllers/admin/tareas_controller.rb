class Admin::TareasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea, only: [:show, :edit, :update, :destroy, :descargar]

  def index
    @tareas = Tarea.includes([:rol,:tipo_instrumento,:descargable_tareas]).order(id: :asc).all
    @tarea = Tarea.new
  end

  def new
    @tarea = Tarea.new
  end

  def edit
  end

  def create
    @tarea = Tarea.new(tarea_params)
    respond_to do |format|
      if @tarea.save
        format.js { 
          flash.now[:success] = 'Tarea correctamente creada.'
          @tarea = Tarea.new
        }
        format.html { redirect_to edit_admin_tarea_url(@tarea), notice: 'Tarea correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @tarea.update(tarea_params)
        format.js { flash.now[:success] = 'Tarea correctamente actualizada.' }
        format.html { redirect_to edit_admin_tarea_url(@tarea), notice: 'Tarea correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @tarea.destroy
    redirect_to admin_tareas_url, notice: 'Tarea correctamente eliminada.'
  end

  def descargar
  end

  private
    def set_tarea
      @tarea = Tarea.find(params[:id])
    end

    def tarea_params
      params.require(:tarea).permit(
        :codigo,
        :etapa_id,
        :tipo_instrumento_id,
        :rol_id,
        :nombre,
        :descripcion,
        :recordatorio_tarea_asunto,
        :recordatorio_tarea_cuerpo,
        :recordatorio_tarea_frecuencia,
        :posee_formulario,
        :cualquiera_con_rol_o_usuario_asignado,
        :condicion_de_acceso,
        :es_una_encuesta,
        :encuesta_id,
        :duracion,
        encuesta_ejecucion_roles_attributes: [
          :id,
          :rol_id,
          :_destroy
        ],
        encuesta_descarga_roles_attributes: [
          :id,
          :rol_id,
          :_destroy
        ]
      )
    end
end
