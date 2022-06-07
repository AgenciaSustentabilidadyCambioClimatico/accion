class InformeImpactosController < ApplicationController
  before_action :authenticate_user!, except: :dirigir_revision
  before_action :set_variables
  before_action :set_informe_impacto, only: [:show, :edit, :update, :destroy, :dirigir_revision]

  # GET /informe_impactos
  def index
    @informe_impacto = InformeImpacto.find_or_initialize_by({manifestacion_de_interes_id: @manifestacion_de_interes.id})
  end
  def revisar
    @informe_impacto = InformeImpacto.find_or_initialize_by({manifestacion_de_interes_id: @manifestacion_de_interes.id})
  end

  # GET /informe_impactos/1
  def show
  end

  # GET /informe_impactos/new
  def new
    @informe_impacto = InformeImpacto.find_or_initialize_by({manifestacion_de_interes_id: @manifestacion_de_interes.id})
  end

  # GET /informe_impactos/1/edit
  def edit
  end

  # POST /informe_impactos
  def create
    
    @informe_impacto = InformeImpacto.new(informe_impacto_params)
    @correcto = false
    if @informe_impacto.save
      unless informe_impacto_params[:documento].blank?
        flash.now[:success] = 'Documento correctamente subido' if @informe_impacto.subida_parcial == 'true'
      end
      flash[:success] = 'Informe correctamente cargado' if @informe_impacto.subida_parcial == 'false'
      if @informe_impacto.subida_parcial == 'true'
        @tarea.pasar_a_siguiente_tarea
        @correcto = true
      end
    end
    flash.now[:alert] = 'Seleccione el documento que desea subir' if informe_impacto_params[:documento].blank?
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /informe_impactos/1
  def update
    @correcto = false
    if @informe_impacto.update(informe_impacto_params)
      unless informe_impacto_params[:documento].blank?
        flash.now[:success] = 'Documento correctamente subido' if @informe_impacto.subida_parcial == 'true'
        flash[:success] = 'Informe correctamente cargado' if @informe_impacto.subida_parcial == 'false'
      else
        flash.now[:alert] = 'Seleccione el documento que desea subir'
      end
      
      if @informe_impacto.subida_parcial != 'true'
        @tarea.pasar_a_siguiente_tarea
        @correcto = true
      end
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /informe_impactos/1
  def destroy
    @informe_impacto.destroy
    redirect_to informe_impactos_url, notice: 'Informe impacto was successfully destroyed.'
  end

  def dirigir_revision
    
    es_rechazo = params[:accion] == 'rechazar' # aca viene desde la url la accion
    @correcto = false # variable que redirige a root en js si es que es correcto
    @informe_impacto.rechazado = es_rechazo
    
    params_to_update = es_rechazo ? {observacion: params[:observaciones]} : informe_impacto_params
    if @informe_impacto.update(params_to_update)
      @correcto = true
      flash[:success] = "Informe correctamente #{es_rechazo ? 'Rechazado' : 'Aceptado' }"
      # aca va la creacion de la nueva tarea pendiente
      condicion_de_salida = es_rechazo ? 'A' : 'B'
      @tarea.pasar_a_siguiente_tarea(condicion_de_salida)
    else
      flash.now[:alert] = 'Ingrese una observación para poder rechazar el informe' if es_rechazo
    end
    respond_to do |format|
      format.js
    end
  end

  private 
    def set_variables
      @tarea = TareaPendiente.includes([:flujo]).find(params[:tarea_pendiente_id])
      autorizado? @tarea
      @flujo = @tarea.flujo
      @tipo_instrumento = @flujo.tipo_instrumento
      @manifestacion_de_interes = ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      @manifestacion_de_interes.update(tarea_codigo: @tarea.tarea.codigo) unless @manifestacion_de_interes.blank?
      @manifestacion_id = @manifestacion_de_interes.id
      @descargable_tareas = DescargableTarea.where(tarea_id: @tarea.tarea_id).order(id: :asc).all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_informe_impacto
      @informe_impacto = InformeImpacto.find_or_initialize_by({manifestacion_de_interes_id: @manifestacion_de_interes.id})
    end

    # Only allow a trusted parameter "white list" through.
    def informe_impacto_params
      params.require(:informe_impacto).permit(:subida_parcial, :observacion, :documento, :documento_cache, :publico, :nombre_documento,:manifestacion_de_interes_id)
    end
end
