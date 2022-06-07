class TraspasoInstrumentosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables

  def new
    @traspaso_instrumento = TraspasoInstrumento.new
  end

  def create
    @traspaso_instrumento = TraspasoInstrumento.new(traspaso_instrumentos_params)

    respond_to do |format|
      if @traspaso_instrumento.save
        set_variables
        format.js { 
          flash.now[:success] = 'Traspaso correctamente realizado.'
          @traspaso_instrumento = TraspasoInstrumento.new
        }
        format.html { redirect_to edit_admin_tarea_url(@tarea), notice: 'Traspaso correctamente realizado.' }
      else
        format.html { render :new }
        format.js
      end
    end


  end

  def usuario_flujos
    @flujos_data = @flujos.map{|f|[f.id.to_s+" - "+f.nombre_instrumento, f.id]}
    @usuarios = User.includes(:personas).where(personas: {contribuyente_id: @personas.pluck(:contribuyente_id)}).where.not(id: @usuario.id)
  end

  private

  def traspaso_instrumentos_params
    params.require(:traspaso_instrumento).permit(
      :origen_id,
      :usuario_origen,
      :flujo_id,
      :destino_id,
      :usuario_destino,
      :tipo_traspaso,
      :fecha_retorno
    )
  end

  def set_variables
    params[:user_id] = params[:origen_id] if params[:user_id].blank? && !params[:origen_id].blank?
    if !current_user.is_admin? || !params[:user_id].blank? 
      @usuario = params[:user_id].blank? ? current_user : User.find(params[:user_id])
      @personas = @usuario.personas
      personas_id = @personas.pluck(:id)
      user_actores = MapaDeActor.where(persona_id: @personas.pluck(:id))
      @flujos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq)
      if !current_user.is_admin?
        @usuarios = User.includes(:personas).where(personas: {contribuyente_id: @personas.pluck(:contribuyente_id)}).where.not(id: @usuario.id)
      end
    else
      @flujos = []
    end
  end

end
