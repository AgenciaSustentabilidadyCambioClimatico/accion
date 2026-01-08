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
      @actor_ids = Array(params[:actor_ids])
      if @actor_ids.any?
        actores = MapaDeActor.where(id: @actor_ids)
        actores_para_mail = actores.to_a

        actores_info = actores_para_mail.map do |a|
          {
            nombre_completo: a.persona.user.nombre_completo,
            rol: a.rol.nombre
          }
        end
        actores.destroy_all
        if params[:actor_ids].count == 1
          flash.now[:success] = 'Registro eliminado correctamente.'
        else
          flash.now[:success] = 'Registros eliminados correctamente.'
        end
        GenericoMailer.elimina_mapa_actores(params[:flujo_id], actores_info).deliver_later
        format.js
      else
        format.js { render js: "alert('No seleccionaste ningún actor.');" }
      end
    end
  end
end
