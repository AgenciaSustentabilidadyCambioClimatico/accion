class RegistroProveedoresController < ApplicationController
  before_action :datos_header_no_signed
  before_action :authenticate_user!, except: [:new, :create]

  def index
  end

  def show
  end

  def new
    @registro_proveedor = RegistroProveedor.new
  end

  def create
    @registro_proveedor = RegistroProveedor.new(registro_proveedores_params)
    respond_to do |format|
      if @registro_proveedor.save
        format.js {


          render js: "window.location='#{root_path}'"
          flash.now[:success] = "Registro enviado correctamente"
        }

      else
        format.html { render :new }
        format.js
      end
    end
  end

  private

  def registro_proveedores_params
    params.require(:registro_proveedor).permit(:rut, :nombre, :apellido, :email, :telefono, :profesion, :direccion, :region, :comuna, :ciudad, :asociar_institucion, :terminos_y_servicion)
  end

  def datos_header_no_signed
    if !user_signed_in?
      @header = ReporteriaDato.find_by(ruta: nil)
    end
  end
end
