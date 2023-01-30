class RegistroProveedoresController < ApplicationController
  include ApplicationHelper
  before_action :datos_header_no_signed
  before_action :authenticate_user!, except: [:new, :create, :get_contribuyentes]

  def index
  end

  # def show
  # end

  def new
    @actividad_economica = ActividadEconomica.where("LENGTH(codigo_ciiuv2) = 2")
    @registro_proveedor = RegistroProveedor.new
    @registro_proveedor.certificado_proveedores.build
    @registro_proveedor.documento_registro_proveedores.build
    @contribuyente    = Contribuyente.new
    @contribuyentes  = Contribuyente.last(100)

    if current_user.nil?
      @tarea = Tarea.find(Tarea::ID_APL_025_1)
    elsif current_user.personas.count == 0
      @tarea = Tarea.find(Tarea::ID_APL_025_2)
    else
      @tarea = Tarea.find(Tarea::ID_APL_025_3)
    end
  end

  def revision
    # if user.con este rol
    # @registro_proveedores = RegistroProveedor.where(usuario_responsable: current_user.id)
    @registro_proveedores = RegistroProveedor.all
    # else
    #   redirect_to root_path
    # end
  end


  def search
    if params[:query].present?
      render json: Contribuyente.last(10)
    end
  end

  def get_contribuyentes
    if params[:search]
      params_contribuyente = params[:search].gsub(/[^0-9\-K]/,'').chop
      @contribuyentes = Contribuyente.where(rut: params_contribuyente)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @contribuyentes }
    end
  end

  def create
    if current_user.nil?
      @tarea = Tarea.find(Tarea::ID_APL_025_1)
    elsif current_user.personas.count == 0
      @tarea = Tarea.find(Tarea::ID_APL_025_2)
    else
      @tarea = Tarea.find(Tarea::ID_APL_025_3)
    end
    @actividad_economica = ActividadEconomica.where("LENGTH(codigo_ciiuv2) = 2")
    @registro_proveedor = RegistroProveedor.new(registro_proveedores_params)
    if params[:region].present? && params[:comuna].present?
      @registro_proveedor.region = Region.find(params[:region].to_i).nombre
      @registro_proveedor.comuna = Comuna.find(params[:comuna].to_i).nombre
    end

    respond_to do |format|

      if @registro_proveedor.save
        RegistroProveedor::CreateService.new(@registro_proveedor, registro_proveedores_params).perform
        format.js {
          render js: "window.location='#{root_path}'"
          flash.now[:success] = "Registro enviado correctamente"
        }
        RegistroProveedorMailer.delay.enviar(@registro_proveedor)
      else
        format.html { render :new }
        format.js
      end
    end
  end


  private

  def registro_proveedores_params
    params.require(:registro_proveedor).permit(:rut, :nombre, :apellido, :email, :telefono, :profesion, :direccion, :region, :comuna, :ciudad, :asociar_institucion, :tipo_contribuyente_id, :terminos_y_servicion,
      :rut_institucion, :nombre_institucion, :tipo_contribuyente, :tipo_proveedor_id, :direccion_casa_matriz, :region_casa_matriz, :comuna_casa_matriz, :ciudad_casa_matriz, :contribuyente_id,
      certificado_proveedores_attributes: [:materia_sustancia_id, :actividad_economica_id, :archivo_certificado, :_destroy], documento_registro_proveedores_attributes: [:description, :archivo, :_destroy])
  end

  def datos_header_no_signed
    if !user_signed_in?
      @header = ReporteriaDato.find_by(ruta: nil)
    end
  end
end
