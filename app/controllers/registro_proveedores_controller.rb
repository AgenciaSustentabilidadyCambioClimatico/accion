class RegistroProveedoresController < ApplicationController
  include ApplicationHelper
  before_action :set_registro_proveedor, only: [:new, :create, :edit, :update, :edit_proveedor, :actualizar_proveedor]
  before_action :datos_header_no_signed
  before_action :authenticate_user!, except: [:new, :create, :get_contribuyentes, :registro_get_comunas]

  #PRO-002
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

  def show
  end

  #PRO-001
  def new
    @registro_proveedor = RegistroProveedor.new
    @registro_proveedor.certificado_proveedores.build
    @registro_proveedor.documento_registro_proveedores.build
  end

  #PRO-001
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
        RegistroProveedorMailer.enviar(@registro_proveedor).deliver_later
      else
        format.html { render :new }
        format.js
      end
    end
  end

  #PRO-002
  def asignar_revisor
    encargados = params[:encargado]
    encargados_seleccionados = encargados.select { |k, v| v.present? }

    encargados_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(user_encargado: value)
      flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
      tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
      tarea = Tarea.where(nombre: "PRO-003").first
      tarea_pendiente.update(tarea_id: tarea.id, user_id: value)
    end
    redirect_to root_path
    flash.now[:success] = "Registro enviado correctamente"
  end

  #PRO-003
  def revision
    if current_user.posee_rol_ascc?(Rol::REVISOR_PROVEEDORES)
     @registro_proveedores = RegistroProveedor.where(user_encargado: current_user.id, estado: 'enviado')
     else
      redirect_to root_path
      flash.now[:success] = "No tienes permiso para acceder a esta pagina"
    end
  end

  #PRO-003
  def revisar_pertinencia
    estados = params[:estado]
    estados_seleccionados = estados.select { |k, v| v.present? }

    estados_seleccionados.each do |k, v|
      key = k
      value = v.to_i
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(estado: value)
      if value == 1
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea = Tarea.where(nombre: "PRO-005").first
        tarea_pendiente.update(tarea_id: tarea.id, user_id: @registro_proveedor.user_encargado)
      elsif value == 3
        @registro_proveedor.update!(rechazo: @registro_proveedor.rechazo + 1)
      end
    end

    comentarios = params[:comentario]
    comentarios_seleccionados = comentarios.select { |k, v| v.present? }

    comentarios_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(comentario: value)


      if @registro_proveedor.estado == 'rechazado' && @registro_proveedor.rechazo <= 1 || @registro_proveedor.estado == 'con_observaciones'
        RegistroProveedorMailer.primer_rechazo(@registro_proveedor).deliver_later
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea = Tarea.where(nombre: "PRO-004").first
        user = User.where(rut: @registro_proveedor.rut).first
        tarea_pendiente.update(tarea_id: tarea.id, user_id: user.id)
      end

      if @registro_proveedor.rechazo > 1
        @registro_proveedor.update!(estado: 6)
        RegistroProveedorMailer.rechazo_definitivo(@registro_proveedor).deliver_later
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea_pendiente.destroy
        flujo.destroy
      end
    end

    redirect_to root_path
    flash.now[:success] = "Registro enviado correctamente"
  end

  #PRO-004
  def edit
    @registro_proveedor = RegistroProveedor.find(params[:id])
    @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
    # if current_user.rut == @registro_proveedor.rut
    #   @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    #   @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
    # else
    #   redirect_to root_path
    #   flash.now[:success] = "No tienes permiso para acceder a esta pagina"
    # end
  end

  #PRO-004
  def update
    @registro_proveedor = RegistroProveedor.find(params[:id])
    asociar_institucion = @registro_proveedor.asociar_institucion
    contribuyente_id = @registro_proveedor.contribuyente_id
    rut_institucion = @registro_proveedor.rut_institucion

    respond_to do |format|
      if @registro_proveedor.update(registro_proveedores_params)
        RegistroProveedor::UpdateService.new(@registro_proveedor, registro_proveedores_params, asociar_institucion, contribuyente_id, rut_institucion).perform
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea = Tarea.where(nombre: "PRO-003").first
        tarea_pendiente.update(tarea_id: tarea.id, user_id: @registro_proveedor.user_encargado)
        format.js {
          render js: "window.location='#{root_path}'"
          flash.now[:success] = "Registro enviado correctamente"
        }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  #PRO-005
  def resultado_revision
    if current_user.posee_rol_ascc?(Rol::REVISOR_PROVEEDORES)
      @registro_proveedores = RegistroProveedor.where(estado: 'recomendado')
      @rechazo_aprobado = RegistroProveedor.select { |registro| registro.estado == 'aprobado' || registro.estado == 'rechazado_directiva'}
    else
      redirect_to root_path
      flash.now[:success] = "No tienes permiso para acceder a esta pagina"
    end
  end

  #PRO-005
  def resultado_de_revision
    estados = params[:estado]
    estados_seleccionados = estados.select { |k, v| v.present? }

    estados_seleccionados.each do |k, v|
      key = k
      value = v.to_i
      @registro_proveedor = RegistroProveedor.find(key)

      if value == 1
        @registro_proveedor.update!(estado: 4)
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea = Tarea.where(nombre: "PRO-007").first
        user = User.where(rut: @registro_proveedor.rut).first
        tarea_pendiente.update(tarea_id: tarea.id, user_id: user.id)
      end

      if value == 2
        @registro_proveedor.update!(rechazo_directiva: @registro_proveedor.rechazo_directiva + 1)
        @registro_proveedor.update!(estado: 5)
      end
    end

    comentarios = params[:comentario]
    comentarios_seleccionados = comentarios.select { |k, v| v.present? }

    comentarios_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(comentario_directiva: value)

      if @registro_proveedor.estado == 'rechazado_directiva'
        RegistroProveedorMailer.primer_rechazo_directiva(@registro_proveedor).deliver_later
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea = Tarea.where(nombre: "PRO-006").first
        user = User.where(rut: @registro_proveedor.rut).first
        tarea_pendiente.update(tarea_id: tarea.id, user_id: user.id)
      end

      if @registro_proveedor.rechazo_directiva > 1
        @registro_proveedor.update!(estado: 6)
        RegistroProveedorMailer.rechazo_definitivo(@registro_proveedor).deliver_later
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea_pendiente.destroy
        # flujo.destroy
      end
    end

    fechas = params[:fecha]
    fechas_seleccionados = fechas.select { |k, v| v.present? }

    fechas_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(fecha_aprobado: value)

      if @registro_proveedor.estado == 'aprobado'
        RegistroProveedorMailer.aprobado_directiva(@registro_proveedor).deliver_later
      end

    end

    archivos = params[:archivo]
    archivos_seleccionados = archivos.select { |k, v| v.present? }

    archivos_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.archivo_respuesta_rechazo_directiva = value
      @registro_proveedor.save!
    end

    redirect_to root_path
    flash.now[:success] = "Registro enviado correctamente"
  end

  #PRO-006
  def edit_proveedor
    # if current_user.rut == @registro_proveedor.rut
    #   @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    #   @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
    # else
    #   redirect_to root_path
    #   flash.now[:success] = "No tienes permiso para acceder a esta pagina"
    # end
    @registro_proveedor = RegistroProveedor.find(params[:id])
    @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
  end

  #PRO-006
  def update_proveedor
    @registro_proveedor = RegistroProveedor.find(params[:id])
    respond_to do |format|
      if @registro_proveedor.update(registro_proveedores_params)
        @registro_proveedor.update(estado: 1)
        flujo = Flujo.where(registro_proveedor_id: @registro_proveedor.id).first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id).first
        tarea = Tarea.where(nombre: "PRO-005").first
        tarea_pendiente.update(tarea_id: tarea.id, user_id: @registro_proveedor.user_encargado)
        format.js {
          render js: "window.location='#{root_path}'"
          flash.now[:success] = "Registro enviado correctamente"
        }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  #PRO-007
  def actualizar_proveedor
    # if current_user.rut == @registro_proveedor.rut
    #   @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    #   @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
    # else
    #   redirect_to root_path
    #   flash.now[:success] = "No tienes permiso para acceder a esta pagina"
    # end
    @registro_proveedor = RegistroProveedor.find(params[:id])
    @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
  end

  #PRO-007
  def update_plazo_proveedor
    @registro_proveedor = RegistroProveedor.find(params[:id])
    respond_to do |format|
      if @registro_proveedor.update(registro_proveedores_params)
        @registro_proveedor.update(estado: 9)
        if @registro_proveedor.region.present? && @registro_proveedor.comuna.present?
          @registro_proveedor.region = Region.find(@registro_proveedor.region.to_i).nombre
          @registro_proveedor.comuna = Comuna.find(@registro_proveedor.comuna.to_i).nombre
          @registro_proveedor.save
        end
        format.js {
          render js: "window.location='#{root_path}'"
          flash.now[:success] = "Registro enviado correctamente"
        }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  #PRO-008
  def resultado_actualizacion
    if current_user.posee_rol_ascc?(Rol::REVISOR_PROVEEDORES)
      @registro_proveedores = RegistroProveedor.where(estado: 'actualizar')
    else
      redirect_to root_path
      flash.now[:success] = "No tienes permiso para acceder a esta pagina"
    end
  end

  #PRO-008
  def resultado_de_actualizacion
    estados = params[:estado]
    estados_seleccionados = estados.select { |k, v| v.present? }

    estados_seleccionados.each do |k, v|
      key = k
      value = v.to_i
      @registro_proveedor = RegistroProveedor.find(key)

      if value == 1
        @registro_proveedor.update!(estado: 9)
      end

      if value == 2
        @registro_proveedor.update!(estado: 8)
        RegistroProveedorMailer.revision_negativa(@registro_proveedor).deliver_now
      end
    end

    fechas = params[:fecha]
    fechas_seleccionados = fechas.select { |k, v| v.present? }

    fechas_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)

      if @registro_proveedor.estado == 'actualizado'
        @registro_proveedor.update!(fecha_revalidacion: value)
        RegistroProveedorMailer.revision_positiva(@registro_proveedor).deliver_now
      end

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
        unless documento.archivo.path.nil?
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
        unless certificado.archivo_certificado.path.nil?
          nombre = certificado.archivo_certificado.file.identifier
          # nombre = "certificado"
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

  def descargar_registro_proveedor_pdf_archivo
    @registro_proveedor = RegistroProveedor.find(params[:id])
    pdf = @registro_proveedor.generar_pdf
    send_data pdf.render, type: "application/pdf", disposition: "attachment", filename: "Registro Proveedor.pdf"
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
      :rut_institucion, :nombre_institucion, :tipo_contribuyente, :tipo_proveedor_id, :direccion_casa_matriz, :region_casa_matriz, :comuna_casa_matriz, :ciudad_casa_matriz, :contribuyente_id, :respuesta_comentario,
      :archivo_respuesta_rechazo, :comentario_directiva, :respuesta_comentario_directiva, :archivo_respuesta_rechazo_directiva, :fecha_aprobado, :fecha_actualizado,
      certificado_proveedores_attributes: [:id, :materia_sustancia_id, :actividad_economica_id, :archivo_certificado, :archivo_certificado_cache, :_destroy], documento_registro_proveedores_attributes: [:id, :description, :archivo, :archivo_cache, :_destroy])
  end

  def datos_header_no_signed
    if !user_signed_in?
      @header = ReporteriaDato.find_by(ruta: nil)
    end
  end
end
