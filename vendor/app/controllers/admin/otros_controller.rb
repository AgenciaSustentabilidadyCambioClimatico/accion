class Admin::OtrosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_otro, only: [:show, :edit, :update, :destroy]
  before_action :set_new_contribuyente, only: [:new, :edit, :create, :update]
  before_action :posee_permisos_administracion_encargado

	def index
    if @acceso == :admin || @acceso == :jefe_de_linea || @acceso == :revisor_tecnico
      @otros = []
      @otro = Otro.new
    else
      persona_cargos = current_user.persona_cargos.where(cargo_id: 14)
      personas = current_user.personas.where(id: persona_cargos.pluck('persona_id'))
      contribuyentes = Contribuyente.where(id: personas.pluck('contribuyente_id'))
      @otros = Otro.where(contribuyente_id: contribuyentes.ids)
    end
	end

  def search
    @contribuyentes = []
    @otros = []
    @otro = Otro.new(params.require(:otro).permit(
      :rut,
      :razon_social,
      :nombre,
      :alcance_id,
      :resultado_mostrados
    ))
    
    # buscar respecto a los datos del contribuyente contribuyente
    if @otro.rut.present? || @otro.razon_social.present?
      @contribuyentes = Contribuyente
      if @otro.rut.present?
        @contribuyentes = @contribuyentes.where("rut = ?", @otro.rut)
        @otros = Otro.where(contribuyente_id: @contribuyentes.pluck(:id))
      end
      if @otro.razon_social.present?
        @contribuyentes = @contribuyentes.where("razon_social ILIKE '%#{@otro.razon_social}%'")
        @otros = Otro.where(contribuyente_id: @contribuyentes.pluck(:id))
      end  
    else
      @otros = Otro    
    end
    #busca respecto a los datos directamente de otros
    if @otro.nombre.present? || @otro.alcance_id.present?    
      unless @otro.nombre.blank?
        @otros = @otros.where("nombre ILIKE '%#{@otro.nombre}%'")
      end
      unless @otro.alcance_id.blank?
        @otros = @otros.where("alcance_id = ?", @otro.alcance_id)
      end
    end
  end

  def new
    acceso_permitido
    @otro = Otro.new
  end

  def create
    @otros = []
    @otro = Otro.new(otro_params)
    respond_to do |format|
      if @otro.save        
        format.js { 
          flash[:success] = 'Otro elemento certificable correctamente creada.'
          @otro = Otro.new
        }
        format.html { redirect_to edit_admin_otro_url(@otro), notice: 'Otro elemento certificable correctamente creado.' }
      else
        errores = @otro.errors.messages.map{|k,v|
          v
        }
        format.html { render :new }
        format.js {
          # DZC 2018-12-28 12:55:59 se agrega mensaje de error al intentar 
          flash[:error] = "Error al crear: #{errores.to_sentence}."
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
      if @otro.update(otro_params)
        format.js { flash[:success] = 'Otro elemento certificable correctamente actualizada'
          render js: "window.location='#{admin_otros_path}'" }
        format.html { redirect_to edit_admin_establecimiento_url(@establecimiento), notice: 'Otro elemento certificable correctamente actualizada' }
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def destroy
    if @otro.adherido_activo?
      error = t(:operación_no_permitida)
    elsif @otro.adherido_inactivo?
      @otro.update(fecha_eliminacion: DateTime.now)
      notice = t(:m_successfully_destroyed, m: t(:otro_elemento_certificable))
    else
      @otro.destroy
      notice = t(:m_successfully_destroyed, m: t(:otro_elemento_certificable))
    end
    redirect_to admin_otros_path, flash: { notice: notice, error: error }
  end

  private
    def set_otro
      @otro = Otro.find(params[:id])
      @contribuyente = @otro.contribuyente
      @otro.rut_contribuyente = @contribuyente.rut_completo
      @otro.nombre_contribuyente = @contribuyente.razon_social
    end

    def set_new_contribuyente
      @contribuyente = @contribuyente.nil? ? Contribuyente.new : @contribuyente
      @contribuyentes  = []      
    end
    def otro_params
      params.require(:otro).permit(
        :establecimiento_contribuyente_id,
        :alcance_id,
        :nombre,
        :contribuyente_id,
        :tipo,
        :identificador_unico,
        :fields_visibility => {},
        imagen: []
      )
    end
    def acceso_permitido
      if @acceso != :admin
        return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      end
    end    
end