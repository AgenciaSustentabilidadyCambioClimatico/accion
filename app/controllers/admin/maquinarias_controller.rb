class Admin::MaquinariasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_new_contribuyente, only: [:new, :edit, :create, :update]
  before_action :set_maquinaria, only: [:show, :edit, :update, :destroy]
  before_action :posee_permisos_administracion_encargado
	def index
    if @acceso == :admin || @acceso == :jefe_de_linea || @acceso == :revisor_tecnico
      @maquinarias = []
      @contribuyente = Contribuyente.new
    else
      persona_cargos = current_user.persona_cargos.where(cargo_id: Cargo::ENCARGADO_INS)
      personas = current_user.personas.where(id: persona_cargos.pluck('persona_id'))
      contribuyentes = Contribuyente.where(id: personas.pluck('contribuyente_id'))
      @maquinarias = Maquinaria.where(contribuyente_id: contribuyentes.ids)
    end
	end

  def search
    @contribuyente = Contribuyente.new(params.require(:contribuyente).permit(
      :rut,
      :razon_social,
      :nombre_maquinaria,
      :numero_serie,
      :patente,
      :actividad_economica_id,
      :es_para_seleccion,
      :buscar_por_actividad_economica,
      :resultado_mostrados
    ))
    @contribuyente.filter_mode = true
    @contribuyente.from_establecimientos = true
    @es_para_seleccion = ( @contribuyente.es_para_seleccion == "true" )
    @buscar_por_actividad_economica = ( @contribuyente.buscar_por_actividad_economica == "true" )
    @resultado_mostrados = @contribuyente.resultado_mostrados
    @filtro_utilizado = []
    @maquinarias = []
    filtro_contribuyente = false
    if @contribuyente.valid?
      @contribuyentes = Contribuyente#.includes([:establecimiento_contribuyentes])      

      unless @contribuyente.rut.blank?
        @contribuyentes = @contribuyentes.where("rut = '?'", @contribuyente.rut)
        filtro = "RUT: #{@contribuyente.rut}"
        @filtro_utilizado << filtro
        filtro_contribuyente = true
      end

      unless @contribuyente.razon_social.blank?
        @contribuyentes = @contribuyentes.where("razon_social ILIKE '%#{@contribuyente.razon_social}%'")
        @filtro_utilizado << "Razón Social: #{@contribuyente.razon_social}"
        filtro_contribuyente = true
      end

      unless @contribuyente.nombre_maquinaria.blank?
        @maquinarias = Maquinaria.where("maquinarias.nombre_maquinaria ILIKE '%#{@contribuyente.nombre_maquinaria}%'")
        filtro = "Nombre de establecimiento: #{@contribuyente.nombre_maquinaria}"
        @filtro_utilizado << filtro
        @contribuyentes =@contribuyentes.where(id: @maquinarias.pluck('contribuyente_id'))
      end

      unless @contribuyente.numero_serie.blank?
        @maquinarias = Maquinaria.where("maquinarias.numero_serie ILIKE '%#{@contribuyente.numero_serie}%'")
        filtro = "Tipo de establecimiento: #{@contribuyente.numero_serie}"
        @filtro_utilizado << filtro
        @contribuyentes =@contribuyentes.where(id: @maquinarias.pluck('contribuyente_id'))
      end

      unless @contribuyente.patente.blank?
        @maquinarias = Maquinaria.where("maquinarias.patente ILIKE '%#{@contribuyente.patente}%'")
        filtro = "Nombre de establecimiento: #{@contribuyente.patente}"
        @filtro_utilizado << filtro
        @contribuyentes =@contribuyentes.where(id: @maquinarias.pluck('contribuyente_id'))
      end

      if !@filtro_utilizado.empty?
        @filtro_utilizado = @filtro_utilizado.join(', ')
      end

      if filtro_contribuyente
        if @maquinarias.empty?
          @maquinarias = Maquinaria.where(contribuyente_id: @contribuyentes.pluck(:id))
        else
          @maquinarias = @maquinarias.where(contribuyente_id: @contribuyentes.pluck(:id))
        end
      end

      @maquinarias = @maquinarias.all unless @maquinarias.empty?
    else
      #ap @contribuyente.errors.messages
      @errors = true
    end
  end
  def new
    acceso_permitido
    @maquinaria = Maquinaria.new
    @establecimientos = []
  end
  def create
    @maquinarias = []
    @maquinaria = Maquinaria.new(maquinaria_params)
    # 
    respond_to do |format|
      if @maquinaria.save        
        format.js { 
          flash[:success] = 'Maquinaria correctamente creada.'
          @maquinaria = Maquinaria.new
        }
        format.html { redirect_to edit_admin_maquinaria_url(@maquinaria), notice: 'maquinaria correctamente creado.' }
      else
        format.html { render :new }
        format.js {
          flash[:error] = "Error al crear."
        }
      end
    end
  end

  def edit
    unless current_user.is_encargado_institucion_solicitada? @contribuyente
      return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
    end
  end
  def update
    respond_to do |format|
      if @maquinaria.update(maquinaria_params)
        format.js { flash[:success] = 'Maquinaria correctamente actualizada'
          render js: "window.location='#{admin_maquinarias_path}'" }
        format.html { redirect_to edit_admin_establecimiento_url(@establecimiento), notice: 'Maquinaria correctamente actualizada' }
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def destroy
    if @maquinaria.adherido_activo?
      error = "No es posible la eliminación"
    elsif @maquinaria.adherido_inactivo?
      @maquinaria.update(fecha_eliminacion: DateTime.now)
      notice = t(:m_successfully_destroyed, m: t(:maquinaria))
    else
      @maquinaria.destroy
      notice = t(:m_successfully_destroyed, m: t(:maquinaria))
    end
    redirect_to admin_maquinarias_path, flash: { notice: notice, error: error}
  end

  def image_download  
    file_name = params[:file_name]
    @filename ="#{Rails.root}/public#{file_name}"
    send_file(@filename , :type => 'application/png/docx/html/htm/doc', :disposition => 'attachment')           
  end

  private
    def set_maquinaria
      @maquinaria = Maquinaria.find(params[:id])
      #Para extraer los datos del contribuyente
      @contribuyente = @maquinaria.contribuyente
      @maquinaria.rut_contribuyente = @contribuyente.rut_completo
      @maquinaria.nombre_contribuyente = @contribuyente.razon_social
    end

    def set_new_contribuyente
      @contribuyente = @contribuyente.nil? ? Contribuyente.new : @contribuyente
      @contribuyentes  = []      
    end

    def maquinaria_params
      params.require(:maquinaria).permit(
        :establecimiento_contribuyente_id,
        :nombre_maquinaria,
        :numero_serie,
        :contribuyente_id,
        :tipo,
        :patente,
        :fields_visibility => {},
        archivos_imagen: []
        )
    end
    def acceso_permitido
      if @acceso != :admin
        return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      end
    end
end