class Admin::EstablecimientosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establecimiento, only: [:show, :edit, :update, :destroy]
  before_action :set_new_contribuyente, only: [:new, :edit, :create, :update]
  before_action :set_variables_territoriales, only: [:new, :edit, :create, :update]
  before_action :es_encargado_institucion, except: [:get_regiones, :get_comunas]
  before_action :sin_permisos, except: [:get_regiones, :get_comunas, :search]

  def index
    if @mis_establecimientos
      persona_cargos = current_user.persona_cargos.where(cargo_id: 14)
      personas = current_user.personas.where(id: persona_cargos.pluck('persona_id'))

      @contribuyentes = Contribuyente.where(id: personas.pluck('contribuyente_id'))
      @establecimientos = EstablecimientoContribuyente.where(contribuyente_id: @contribuyentes.ids)
    else
      @establecimientos = []
      @contribuyente = Contribuyente.new
    end 
  end

  def search
    @contribuyente = Contribuyente.new(params.require(:contribuyente).permit(
      :rut,
      :razon_social,
      :actividad_economica_id,
      :es_para_seleccion,
      :buscar_por_actividad_economica,
      :resultado_mostrados,
      :nombre_de_establecimiento,
      :tipo_de_establecimiento
    ))
    @contribuyente.filter_mode = true
    @contribuyente.from_establecimientos = true
    @es_para_seleccion = ( @contribuyente.es_para_seleccion == "true" )
    @buscar_por_actividad_economica = ( @contribuyente.buscar_por_actividad_economica == "true" )
    @resultado_mostrados = @contribuyente.resultado_mostrados
    @filtro_utilizado = []
    @establecimientos = []
    filtro_contribuyente = false
    if @contribuyente.valid?
      @contribuyentes = Contribuyente#.includes([:establecimiento_contribuyentes])

      unless @contribuyente.razon_social.blank?
        @contribuyentes = @contribuyentes.where("razon_social ILIKE '%#{@contribuyente.razon_social}%'")
        @filtro_utilizado << "Razón Social: #{@contribuyente.razon_social}"
        filtro_contribuyente = true
      end

      unless @contribuyente.rut.blank?
        @contribuyentes = @contribuyentes.where("rut = '?'", @contribuyente.rut)
        filtro = "RUT: #{@contribuyente.rut}"
        @filtro_utilizado << filtro
        filtro_contribuyente = true
      end

      unless @contribuyente.nombre_de_establecimiento.blank?
        @establecimientos = EstablecimientoContribuyente.where("establecimiento_contribuyentes.nombre_de_establecimiento ILIKE '%#{@contribuyente.nombre_de_establecimiento}%'")
        filtro = "Nombre de establecimiento: #{@contribuyente.nombre_de_establecimiento}"
        @filtro_utilizado << filtro
      end

      unless @contribuyente.tipo_de_establecimiento.blank?
        @establecimientos = @establecimientos.where("establecimiento_contribuyentes.tipo_de_establecimiento ILIKE '%#{@contribuyente.tipo_de_establecimiento}%'")
        filtro = "Tipo de establecimiento: #{@contribuyente.tipo_de_establecimiento}"
        @filtro_utilizado << filtro
      end

      if !@filtro_utilizado.empty?
        @filtro_utilizado = @filtro_utilizado.join(', ')
      end

      if filtro_contribuyente
        if @establecimientos.empty?
          @establecimientos = EstablecimientoContribuyente.where(contribuyente_id: @contribuyentes.pluck(:id))
        else
          @establecimientos = @establecimientos.where(contribuyente_id: @contribuyentes.pluck(:id))
        end
      end

      @establecimientos = @establecimientos.all unless @establecimientos.empty?
      @contribuyente = Contribuyente.new
    else
      #ap @contribuyente.errors.messages
      @errors = true
    end
  end

  def new
    @establecimiento = EstablecimientoContribuyente.new
    @establecimientos = []
  end

  def edit
    @establecimientos = []
  end

  def create
    @establecimientos = []
    @establecimiento = EstablecimientoContribuyente.new(establecimiento_params)
    respond_to do |format|
      if @establecimiento.save
        format.js { 
          flash[:success] = 'Establecimiento correctamente creado.'
          @establecimiento = EstablecimientoContribuyente.new
        }
        format.html { redirect_to edit_admin_establecimiento_url(@establecimiento), notice: 'Establecimiento correctamente creado.' }
      else
        format.html { render :new }
        format.js {
          flash[:error] = "Error al crear."
        }
      end
    end
  end

  def update
    respond_to do |format|
      if @establecimiento.update(establecimiento_params)
        format.js { flash[:success] = 'Establecimiento correctamente actualizado'
          render js: "window.location='#{admin_establecimientos_path}'" }
        format.html { redirect_to edit_admin_establecimiento_url(@establecimiento), notice: 'Establecimiento correctamente actualizado' }
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def destroy
    if @establecimiento.adherido_activo?
      error = "No es posible la eliminación"
    elsif @establecimiento.adherido_inactivo?
      @establecimiento.update(fecha_eliminacion: DateTime.now)
      notice = t(:m_successfully_destroyed, m: t(:establecimiento))
    else
      @establecimiento.destroy
      notice = t(:m_successfully_destroyed, m: t(:establecimiento))
    end
    redirect_to admin_establecimientos_url, flash: { notice: notice, error: error}
  end

  def get_regiones
    @pais = Pais.find params[:pais_id]
    @regiones = @pais.regiones.order('nombre').vigente?
  end

  def get_comunas
    @region = Region.find params[:region_id]
    @comunas = @region.comunas.order('nombre').vigente?
  end

  private
    def set_establecimiento
      @establecimientos = []
      @establecimiento = EstablecimientoContribuyente.find(params[:id])
      @contribuyente = @establecimiento.contribuyente
      @establecimiento.rut_contribuyente = @contribuyente.rut_completo
      @establecimiento.nombre_contribuyente = @contribuyente.razon_social
      @establecimiento.pais.present? ? @regiones_select = @establecimiento.pais.regiones.map{|u| [u.nombre, u.id]} : @regiones_select =[]
      @establecimiento.region.present? ? @comunas_select = @establecimiento.region.comunas.map{|u| [u.nombre, u.id]} : @comunas_select =[]
    end

    def set_new_contribuyente
      @contribuyente = @contribuyente.nil? ? Contribuyente.new : @contribuyente      
      @contribuyentes  = []
      @regiones_select =[] if @regiones_select.nil?
      @comunas_select =[] if @comunas_select.nil?
    end

    def establecimiento_params
      params.require(:establecimiento_contribuyente).permit(
        :contribuyente_id,
        :casa_matriz,
        :direccion,
        :ciudad,
        :pais_id,
        :region_id,
        :comuna_id,
        :latitud,
        :longitud,
        :nombre_de_establecimiento,
        :tipo_de_establecimiento,
        :telefono,
        :email,
        :rut_contribuyente, 
        :nombre_contribuyente,
        :fields_visibility => {}
      )
    end

    def set_variables_territoriales
      @regiones= Region.all
      @comunas= Comuna.all
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
      @mis_establecimientos = @encargado
      @mis_establecimientos = false if current_user.is_admin?
    end

    def sin_permisos
      unless current_user.is_admin? || @encargado || current_user.posee_rol_ascc?([Rol::JEFE_DE_LINEA,Rol::REVISOR_TECNICO])
        return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      end      
    end
end
