class RegistroProveedoresController < ApplicationController
  before_action :datos_header_no_signed
  before_action :authenticate_user!, except: [:new, :create]

  def index
  end

  def show
  end

  def new
    @actividad_economica = ActividadEconomica.where("LENGTH(codigo_ciiuv2) = 2")
    @registro_proveedor = RegistroProveedor.new
    @registro_proveedor.certificado_proveedores.build
    @registro_proveedor.documento_registro_proveedores.build
  end

  def create
    @actividad_economica = ActividadEconomica.where("LENGTH(codigo_ciiuv2) = 2")
    @registro_proveedor = RegistroProveedor.new(registro_proveedores_params)
    respond_to do |format|
      if @registro_proveedor.save
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
      :rut_institucion, :nombre_institucion, :tipo_contribuyente, :direccion_casa_matriz, :region_casa_matriz, :comuna_casa_matriz, :ciudad_casa_matriz,
      certificado_proveedores_attributes: [:materia_sustancia_id, :actividad_economica_id, :archivo_certificado, :_destroy], documento_registro_proveedores_attributes: [:description, :archivo, :_destroy])
  end

  def datos_header_no_signed
    if !user_signed_in?
      @header = ReporteriaDato.find_by(ruta: nil)
    end
  end
end
