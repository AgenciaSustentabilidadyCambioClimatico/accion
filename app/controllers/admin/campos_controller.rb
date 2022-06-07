class Admin::CamposController < ApplicationController
  before_action :authenticate_user!
  before_action :soy_admin?
  before_action :set_campo, only: [:actualizar_campos, :actualiza_campos]

  def index
    tarea_ids = CampoTarea.all.pluck(:tarea_id).uniq
    @tareas = Tarea.where(id: tarea_ids)
  end

  def actualiza_campos
    # DOSSA 23-07-2019 se corrige para enviar mensajes correctamente.
    respond_to do |format|
      if @campo.update(campo_params)
        format.html { redirect_to admin_lista_campos_path(@campo.tareas.first.id), notice: 'Campos correctamente actualizados.' }
        format.js { redirect_to admin_lista_campos_path(@campo.tareas.first.id), notice: 'Campos correctamente actualizados.'}
      else
        format.html { render :actualizar_campos }
        format.js
      end
    end
  end

  def actualizar_campos
  end

  def lista_campos
    # DZC 2019-07-25 17:26:02 se modifica para listar el nombre de la tarea en la vista
    @tarea = Tarea.find(params[:id])
    @campos = @tarea.campos
  end

  private

    def set_campo
      # DOSSA 23-07-2019 se definen variables a utilizar en la vista.
      @campo = Campo.find(params[:id])
    end

    def campo_params
      # DOSSA 23-07-2019 se modifica para pasar los campos correspondientes como parámetros
      params.require(:campo).permit(
        :id, 
        :nombre,
        :validaciones_activas, 
        :validacion_contenido_obligatorio,
        :validacion_vacio_mensaje,
        :validacion_min,
        :validacion_min_activa,
        :validacion_max,
        :validacion_max_activa, 
        :tooltip, 
        :tooltip_activo, 
        :ayuda,
        :ayuda_activo
      )
    end

    def soy_admin?
      unless current_user.is_admin?
        flash[:warning] = 'No tiene permiso para acceder a esta tarea'
        redirect_to root_path
      end
    end
end