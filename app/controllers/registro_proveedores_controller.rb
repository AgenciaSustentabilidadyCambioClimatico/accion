class RegistroProveedoresController < ApplicationController
  include ApplicationHelper
  before_action :set_registro_proveedor, only: [:new, :create]
  before_action :datos_header_no_signed
  before_action :authenticate_user!, except: [:new, :create, :get_contribuyentes]

  def index
    # @registro_proveedor = RegistroProveedor.find(params[:registro_proveedor_id])
    # user = Responsable.__personas_responsables(Rol::JEFE_DE_LINEA_PROVEEDORES, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)
    # habilitado = user.select { |f| f.id == current_user.id }
    # if habilitado.present?
    if current_user.posee_rol_ascc?(Rol::JEFE_DE_LINEA_PROVEEDORES)
      @registro_proveedores = RegistroProveedor.all
      @users = Responsable.__personas_responsables(Rol::REVISOR_PROVEEDORES, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)
    else
      redirect_to root_path
      flash.now[:success] = "Registro enviado correctamente"
    end
  end

  # def show
  # end

  def asignar_revisor
    encargados = params[:encargado]
    encargados_seleccionados = encargados.select { |k, v| v.present? }

    encargados_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(user_encargado: value)
    end
    redirect_to root_path
    flash.now[:success] = "Registro enviado correctamente"
  end

  def revision
    # if user.con este rol
     @registro_proveedores = RegistroProveedor.where(user_encargado: current_user.id)
    # else
    #   redirect_to root_path
    # end
  end

  def revisar_pertinencia
    estados = params[:estado]
    estados_seleccionados = estados.select { |k, v| v.present? }

    estados_seleccionados.each do |k, v|
      key = k
      value = v.to_i
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(estado: value)
      if value == 3
        @registro_proveedor.update!(rechazo: @registro_proveedor.rechazo + 1)
      end
      # if @registro_proveedor.rechazo > 1
      #   @registro_proveedor.update!(estado: 5)
      #   Mail para avisar que no puede mandar mas
      # end
    end

    comentarios = params[:comentario]
    comentarios_seleccionados = comentarios.select { |k, v| v.present? }

    comentarios_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(comentario: value)
    end

    redirect_to root_path
    flash.now[:success] = "Registro enviado correctamente"
  end

  def descargar_documentos_proveedores
    require 'zip'
    archivo_zip = Zip::OutputStream.write_buffer do |stream|
      registro_proveedor = RegistroProveedor.unscoped.find(params[:id])
      documentos = registro_proveedor.documento_registro_proveedores
      documentos.each do |documento|
        if File.exists?(documento.archivo.path)
          #nombre = documento.archivo.file.identifier
          nombre = "#{registro_proveedor.rut} - #{registro_proveedor.nombre} - #{documento.archivo.file.identifier}"
          # rename the file
          stream.put_next_entry(nombre)
          # add file to zip
          stream.write IO.read((documento.archivo.current_path rescue documento.archivo.path))
        end
      end
      certificados = registro_proveedor.certificado_proveedores
      certificados.each do |certificado|
        if File.exists?(certificado.archivo_certificado.path)
          #nombre = certificado.archivo_certificado.file.identifier
          nombre = "certificado"
          # rename the file
          stream.put_next_entry(nombre)
          # add file to zip
          stream.write IO.read((certificado.archivo_certificado.current_path rescue certificado.archivo_certificado.path))
        end
      end
    end

    archivo_zip.rewind
    #enviamos el archivo para ser descargado
    send_data archivo_zip.sysread, type: 'application/zip', charset: "iso-8859-1", filename: "documentacion.zip"
  end

  def new
    @registro_proveedor = RegistroProveedor.new
    @registro_proveedor.certificado_proveedores.build
    @registro_proveedor.documento_registro_proveedores.build
  end

  def create
    @registro_proveedor = RegistroProveedor.new(registro_proveedores_params)
    if params[:registro_proveedor][:region].present? && params[:registro_proveedor][:comuna].present?
      @registro_proveedor.region = Region.find(params[:registro_proveedor][:region].to_i).nombre
      @registro_proveedor.comuna = Comuna.find(params[:registro_proveedor][:comuna].to_i).nombre
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

  def get_contribuyentes
    if params[:search]
      params_contribuyente = params[:search].tr('^0-9', '').chop
      @contribuyentes = Contribuyente.where(rut: params_contribuyente)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @contribuyentes }
    end
  end

  def registro_get_comunas
    @region = Region.find params[:id]
    @comunas = @region.comunas.order('nombre').vigente?
  end

  def registro_get_comunas_casa_matriz
    @region = Region.find params[:id]
    @comunas = @region.comunas.order('nombre').vigente?
  end


  private

  def set_registro_proveedor
    if current_user.nil?
      @tarea = Tarea.find(Tarea::ID_APL_025_1)
    elsif current_user.personas.count == 0
      @tarea = Tarea.find(Tarea::ID_APL_025_2)
    else
      @tarea = Tarea.find(Tarea::ID_APL_025_3)
    end
    @actividad_economica = ActividadEconomica.where("LENGTH(codigo_ciiuv4) = 2").sort
    @tipo_de_proveedores = TipoProveedor.where(solo_asignable_por_ascc: true)
  end

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
