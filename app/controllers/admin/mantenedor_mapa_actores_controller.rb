class Admin::MantenedorMapaActoresController < ApplicationController
    before_action :authenticate_user!

  def index
    @flujo = Flujo.new
    @fondo_produccion_limpia = FondoProduccionLimpia.new

    personas = current_user.personas
    personas_id = personas.pluck(:id)
    user_actores = MapaDeActor.where(persona_id: personas.pluck(:id))

    if current_user.is_admin? || current_user.is_ascc?
      @instrumentos = Flujo.order(id: :desc)
    else
      @instrumentos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq).order(id: :desc)
    end
    @apls = @instrumentos.where.not(manifestacion_de_interes_id: nil)
  
  end

  def obtener
    @mapa_actores = MapaDeActor.where(flujo_id: params[:apl_id])
    render json: { html: render_to_string(partial: "admin/mantenedor_mapa_actores/lista", locals: { mapa_actores: @mapa_actores }) }
  end

  def eliminar
    respond_to do |format|
      if params[:actor_ids].present?
        @actor_ids = params[:actor_ids]
        MapaDeActor.where(id: @actor_ids).destroy_all
        if params[:actor_ids].count == 1
          flash.now[:success] = 'Registro eliminado correctamente.'
        else
          flash.now[:success] = 'Registros eliminados correctamente.'
        end
        format.js
      else
        format.js { render js: "alert('No seleccionaste ningún actor.');" }
      end
    end
  end
end
