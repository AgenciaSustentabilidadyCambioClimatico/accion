class Admin::ContribuyentesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contribuyente, only: [:show, :edit, :update, :destroy]
  before_action :es_encargado_institucion
  before_action :sin_permisos, except: [:search]

  def index
    if @mis_instituciones
      persona_cargos = current_user.persona_cargos.where(cargo_id: Cargo::ENCARGADO_INS)
      personas = current_user.personas.where(id: persona_cargos.pluck('persona_id'))

      @contribuyentes = Contribuyente.where(id: personas.pluck('contribuyente_id'))
    else
      @contribuyentes = []
      @contribuyente = Contribuyente.new 
    end  
  end

  def search
#DZC
#    @contribuyente = Contribuyente.new(params.require(:contribuyente).permit(
#      :rut,
#      :razon_social,
#      :actividad_economica_id,
#      :es_para_seleccion,
#      :buscar_por_actividad_economica,
#      :resultado_mostrados,
#      :es_maquinaria
#    ))
#DZC
#DZC Gino
    @contribuyente = Contribuyente.new(params.require(:contribuyente).permit(
      :rut,
      :razon_social,
      :actividad_economica_id,
      :es_para_seleccion,
      :seleccion_basica,
      :tipo_instrumento,
      :buscar_por_actividad_economica,
      :resultado_mostrados,
      :es_maquinaria,
      :custom_id,
      :data_table
    ))
    @custom_id = @contribuyente.custom_id
#DZC
    @contribuyente.filter_mode = true
    @es_para_seleccion = ( @contribuyente.es_para_seleccion == "true" )
    @seleccion_basica = @contribuyente.seleccion_basica
    @tipo_instrumento = @contribuyente.tipo_instrumento
    @es_maquinaria = ( @contribuyente.es_maquinaria == "true" )
    
    @buscar_por_actividad_economica = ( @contribuyente.buscar_por_actividad_economica == "true" )
    @resultado_mostrados = @contribuyente.resultado_mostrados
#DZC Gino
    @data_table = (@contribuyente.data_table == "true")
#DZC
    if @contribuyente.valid?
      if @seleccion_basica == "true"
        @contribuyentes = Contribuyente
      else
        @contribuyentes = Contribuyente.includes([:actividad_economica_contribuyentes,:dato_anual_contribuyentes,:establecimiento_contribuyentes])
      end
      if @contribuyente.actividad_economica_id.blank?
        unless @contribuyente.razon_social.blank?
          @contribuyentes = @contribuyentes.where("razon_social ILIKE '%#{@contribuyente.razon_social}%'")
          @filtro_utilizado = "Razón Social: #{@contribuyente.razon_social}"
        end
        unless @contribuyente.rut.blank?
          @contribuyentes = @contribuyentes.where("rut = ?", @contribuyente.rut)
          filtro = "RUT: #{@contribuyente.rut}"
          if @filtro_utilizado.blank?
            @filtro_utilizado = filtro
          else
            @filtro_utilizado = " Y #{filtro}"
          end
        end
        @contribuyentes = @contribuyentes.all
      else
        @contribuyentes = @contribuyentes
          .joins(:actividad_economica_contribuyentes)
          .where("actividad_economica_contribuyentes.actividad_economica_id = (?)",@contribuyente.actividad_economica_id)
        @filtro_utilizado = "Actividad Económica : #{ActividadEconomica.find(@contribuyente.actividad_economica_id).descripcion}"
      end
      @contribuyente = Contribuyente.new
    else
      @errors = true
    end
  end

  #permite realizar busqueda por rut o razon social y devolver unicamente los datos del contribuyente.-
  #Se debe usar de querer utilizar _form_manifestacion_de_interes_cambio_gestor.html
  # def search_contribuyente    
  #   #Datos necesarios para el buscador
  #   @errors = false
  #   @filtro_utilizado = []
  #   @es_para_seleccion = true
  #   #obtiene los parametos de la consulta
  #   rut = params[:rut]
  #   razon_social = params[:razon_social]
  #   #set contribuyentes para que sea un objeto de la clase
  #   @contribuyentes = Contribuyente
  #   if razon_social.present?
  #     @contribuyentes = @contribuyentes.where("razon_social ILIKE '%#{razon_social}%'")
  #     @filtro_utilizado = "Razón Social: #{razon_social}"
  #   end
  #   if rut.present?
  #     @contribuyentes = @contribuyentes.where("rut = ?", rut)
  #     filtro = "RUT: #{rut}"
  #     if @filtro_utilizado.blank?
  #       @filtro_utilizado = filtro
  #     else
  #       @filtro_utilizado = " Y #{filtro}"
  #     end
  #   end
  # end

  def new
    @contribuyente = Contribuyente.new
  end

  def edit
  end

  def create
    parameters = contribuyente_params
    @contribuyente = Contribuyente.new(parameters)
    casa_matriz_set = parameters.to_h["establecimiento_contribuyentes_attributes"].select{|k,v| v["casa_matriz"] == "1"}.size > 0
    respond_to do |format|
      if casa_matriz_set && @contribuyente.save
        format.js { 
          flash.now[:success] = 'Institución correctamente creada.'
          @contribuyente = Contribuyente.new
        }
        format.html { redirect_to edit_admin_contribuyente_url(@contribuyente), notice: 'Institución correctamente creada.' }
      else
        
        flash[:error] = "Debe seleccionar una casa matriz" unless casa_matriz_set
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    #se usa select porque where hace llamada a bd y trae info aun no guardada o actualizada
    casa_matriz_set = contribuyente_params.to_h["establecimiento_contribuyentes_attributes"].select{|k,v| v["casa_matriz"] == "1"}.size > 0
    respond_to do |format|
      if casa_matriz_set && @contribuyente.update(contribuyente_params)
        format.js { flash.now[:success] = 'Institución correctamente actualizada' }
        format.html { redirect_to edit_admin_contribuyente_url(@contribuyente), notice: 'Institución correctamente actualizada' }
      else
        flash[:error] = "Debe seleccionar una casa matriz" unless casa_matriz_set
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @contribuyente.destroy
    redirect_to admin_contribuyentes_url, notice: 'Institución correctamente eliminada.'
  end

  #metodos para la edicion desde mi cuenta
  def mis_instituciones
    
    render 'admin/contribuyentes/mi_cuenta/index'
  end

  def region_comunas
    @codigo = params[:codigo]
    @comunas = Comuna.__select nil, params[:region_id]
  end

  private
    def set_contribuyente
      @contribuyente = Contribuyente.find(params[:id])
    end

    def contribuyente_params
      params.require(:contribuyente).permit(
        :rut,
        :dv,
        :razon_social,
        fields_visibility: {},
        actividad_economica_contribuyentes_attributes: [ :id, :actividad_economica_id, :_destroy ],
        establecimiento_contribuyentes_attributes: [ :id, :casa_matriz, :direccion, :ciudad, :region_id, :comuna_id, :_destroy ],
        dato_anual_contribuyentes_attributes: [ :id, :tipo_contribuyente_id, :rango_venta_contribuyente_id, :periodo, :numero_trabajadores, :f22c_645, :f22c_646, :_destroy ]
      )
    end
    #variable para determinar si posee el cargo encargado de institucion
    def es_encargado_institucion
      if @contribuyente.present? 
        @encargado = current_user.is_encargado_institucion_solicitada? @contribuyente
      elsif action_name == "index"
        @encargado =  current_user.is_encargado_institucion?
      else
        @encargado =  false
      end
      @mis_instituciones = @encargado
      @mis_instituciones = false if (current_user.is_admin? || current_user.posee_rol_ascc?([Rol::JEFE_DE_LINEA,Rol::REVISOR_TECNICO]))
    end

    def sin_permisos
      unless current_user.is_admin? || @encargado || current_user.posee_rol_ascc?([Rol::JEFE_DE_LINEA,Rol::REVISOR_TECNICO])
        return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      end      
    end

end
