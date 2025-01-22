class RegistroProveedoresController < ApplicationController
  include ApplicationHelper
  before_action :set_registro_proveedor, only: [:new, :create, :edit, :update, :edit_proveedor, :actualizar_proveedor]
  before_action :datos_header_no_signed
  before_action :authenticate_user!, except: [:new, :create, :get_contribuyentes, :registro_get_comunas, :registro_get_comunas_casa_matriz, :get_by_rut]
  before_action :get_apl, only: [:get_apl]

  # PRO-002
  def index
    # @registro_proveedor = RegistroProveedor.find(params[:registro_proveedor_id])
    # user = Responsable.__personas_responsables(Rol::JEFE_DE_LINEA_PROVEEDORES, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)
    # habilitado = user.select { |f| f.id == current_user.id }
    # if habilitado.present?
    if current_user.posee_rol_ascc?(Rol::JEFE_DE_LINEA_PROVEEDORES)
      @registro_proveedores = RegistroProveedor.where(user_encargado: nil)
      @users = Responsable.responsables_por_rol(Rol::REVISOR_PROVEEDORES)
    else
      redirect_to root_path
      flash.now[:success] = "Registro enviado correctamente"
    end
  end

  def show; end

  # PRO-001
  def new
    @tarea = Tarea.find(101)
    @descargables_tarea = DescargableTarea.where(tarea_id: 101)
    @registro_proveedor = RegistroProveedor.new
    @registro_proveedor.certificado_proveedores.build
    @registro_proveedor.documento_registro_proveedores.build
  end

  # PRO-001
  def create
    @tarea = Tarea.find(101)
    @descargables_tarea = DescargableTarea.where(tarea_id: 101)
    @registro_proveedor = RegistroProveedor.new(registro_proveedores_params)
    if params[:registro_proveedor][:region].present? && params[:registro_proveedor][:comuna].present?
      @registro_proveedor.region = Region.find(params[:registro_proveedor][:region].to_i).nombre
      @registro_proveedor.comuna = Comuna.find(params[:registro_proveedor][:comuna].to_i).nombre
    end

    if params[:registro_proveedor][:region_casa_matriz].present? && params[:registro_proveedor][:comuna_casa_matriz].present?
      @registro_proveedor.region_casa_matriz = Region.find(params[:registro_proveedor][:region_casa_matriz].to_i).nombre
      @registro_proveedor.comuna_casa_matriz = Comuna.find(params[:registro_proveedor][:comuna_casa_matriz].to_i).nombre
    end

    respond_to do |format|
      if @registro_proveedor.save
        RegistroProveedor::CreateService.new(@registro_proveedor, registro_proveedores_params).perform
        format.js {
          render js: "window.location='#{root_path}'"
          flash[:success] = "Registro enviado correctamente"
        }
        RegistroProveedorMailer.enviar(@registro_proveedor).deliver_later
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PRO-002
  def asignar_revisor
    encargados = params[:encargado]
    encargados_seleccionados = encargados.select { |k, v| v.present? }

    encargados_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(user_encargado: value)
      flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
      tarea = Tarea.where(codigo: 'PRO-003').first
      send_message(tarea, value)
      TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: value, data: @registro_proveedor.id)
      tarea_previa = Tarea.where(codigo: 'PRO-002').first
      tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
      tarea_pendiente.first.delete
    end
    redirect_to root_path
    flash[:success] = 'Registro enviado correctamente'
  end

  # PRO-003
  def revision
    if current_user.posee_rol_ascc?(Rol::REVISOR_PROVEEDORES)
      @registro_proveedores = RegistroProveedor.where(user_encargado: current_user.id, estado: 'enviado')
    else
      redirect_to root_path
      flash[:success] = 'No tienes permiso para acceder a esta pagina'
    end
  end

  # PRO-003
  def revisar_pertinencia
    estados = params[:estado]
    estados_seleccionados = estados.select { |k, v| v.present? }

    estados_seleccionados.each do |k, v|
      key = k
      value = v.to_i
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(estado: value)
      if value == 1
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea = Tarea.where(codigo: "PRO-005").first
        send_message(tarea, @registro_proveedor.user_encargado)
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: @registro_proveedor.user_encargado, data: @registro_proveedor.id)
        tarea_previa = Tarea.where(codigo: 'PRO-003').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
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
        if @registro_proveedor.estado == 'rechazado'
          RegistroProveedorMailer.primer_rechazo(@registro_proveedor).deliver_later
        elsif @registro_proveedor.estado == 'con_observaciones'
          RegistroProveedorMailer.con_observaciones(@registro_proveedor).deliver_later
        end
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea = Tarea.where(codigo: 'PRO-004').first
        user = User.where(rut: @registro_proveedor.rut).first
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: user.id)
        tarea_previa = Tarea.where(codigo: 'PRO-003').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
      end

      if @registro_proveedor.rechazo > 1
        @registro_proveedor.update!(estado: 6)
        RegistroProveedorMailer.rechazo_definitivo(@registro_proveedor).deliver_later
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea_previa = Tarea.where(codigo: 'PRO-003').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
      end
    end

    redirect_to root_path
    flash[:success] = "Registro enviado correctamente"
  end

  #PRO-004
  def edit
    @editar = params[:editar]

    @tarea = Tarea.find(104)
    @descargables_tarea = DescargableTarea.where(tarea_id: 104)
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
    @editar = params[:editar]
    @registro_proveedor = RegistroProveedor.find(params[:id])
    puts "--------> #{@registro_proveedor.inspect}"
    asociar_institucion = @registro_proveedor.asociar_institucion
    contribuyente_id = @registro_proveedor.contribuyente_id
    rut_institucion = @registro_proveedor.rut_institucion
    registro_proveedores_params_sin_editar = registro_proveedores_params.except(:editar)
    respond_to do |format|
      if @registro_proveedor.update(registro_proveedores_params_sin_editar)
        if registro_proveedores_params_sin_editar[:carta_compromiso].nil?
          RegistroProveedor::UpdateService.new(@registro_proveedor, registro_proveedores_params, asociar_institucion, contribuyente_id, rut_institucion).perform

          if params[:registro_proveedor][:editar] != 'true'
            flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
            tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, user_id: current_user.id).first
            tarea_pendiente.destroy
            tarea = Tarea.where(codigo: "PRO-003").first
            send_message(tarea, @registro_proveedor.user_encargado)
            TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: @registro_proveedor.user_encargado, data: @registro_proveedor.id)
          end
       end
        format.js {
          render js: "window.location='#{root_path}'"
          flash[:success] = "Registro enviado correctamente"
        }
        format.html {
          redirect_to root_path
          flash[:success] = "Registro enviado correctamente"
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
      flash[:success] = "No tienes permiso para acceder a esta pagina"
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
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea = Tarea.where(codigo: 'PRO-007').first
        user = User.where(rut: @registro_proveedor.rut).first
        send_message(tarea, user.id)
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: user.id, data: @registro_proveedor.id)
        tarea_previa = Tarea.where(codigo: 'PRO-005').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
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
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea = Tarea.where(codigo: 'PRO-006').first
        user = User.where(rut: @registro_proveedor.rut).first
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: user.id)
        tarea_previa = Tarea.where(codigo: 'PRO-005').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
      end

      if @registro_proveedor.rechazo_directiva > 1
        @registro_proveedor.update!(estado: 6)
        RegistroProveedorMailer.rechazo_definitivo(@registro_proveedor).deliver_later
        tarea_previa = Tarea.where(codigo: 'PRO-005').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
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
    flash[:success] = "Registro enviado correctamente"
  end

  # PRO-006
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

  # PRO-006
  def update_proveedor
    @registro_proveedor = RegistroProveedor.find(params[:id])
    respond_to do |format|
      if @registro_proveedor.update(registro_proveedores_params)
        @registro_proveedor.update(estado: 1)
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, user_id: current_user.id).first
        tarea_pendiente.destroy
        tarea = Tarea.where(codigo: 'PRO-005').first
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: @registro_proveedor.user_encargado, data: @registro_proveedor.id)

        format.js {
          render js: "window.location='#{root_path}'"
          flash[:success] = "Registro enviado correctamente"
        }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  # PRO-007
  def actualizar_proveedor
    # if current_user.rut == @registro_proveedor.rut
    #   @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    #   @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
    # else
    #   redirect_to root_path
    #   flash.now[:success] = "No tienes permiso para acceder a esta pagina"
    # end

    @registro_proveedor = RegistroProveedor.find(params[:id])
    @registro_proveedor.certificado_proveedor_extras.build
    @registro_proveedor.documento_proveedor_extras.build
    @region = Region.where(nombre: "#{@registro_proveedor.region}").last.id
    @comuna = Comuna.where(nombre: "#{@registro_proveedor.comuna}").last.id
  end

  # PRO-007
  def update_plazo_proveedor
    @registro_proveedor = RegistroProveedor.find(params[:id])
    respond_to do |format|
      if @registro_proveedor.update(registro_proveedores_params)
        @registro_proveedor.update(estado: 9)
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea = Tarea.where(codigo: "PRO-008").first
        user = User.where(rut: @registro_proveedor.rut).first
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: @registro_proveedor.user_encargado, data: @registro_proveedor.id)
        tarea_previa = Tarea.where(codigo: 'PRO-007').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
        if @registro_proveedor.region.present? && @registro_proveedor.comuna.present?
          @registro_proveedor.region = Region.find(@registro_proveedor.region.to_i).nombre
          @registro_proveedor.comuna = Comuna.find(@registro_proveedor.comuna.to_i).nombre
          @registro_proveedor.save
        end
        format.js {
          render js: "window.location='#{root_path}'"
          flash[:success] = "Registro enviado correctamente"
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
      @registro_proveedores = RegistroProveedor.where(estado: 'actualizado')
    else
      redirect_to root_path
      flash[:success] = "No tienes permiso para acceder a esta pagina"
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
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea = Tarea.where(codigo: "PRO-009").first
        user = User.where(rut: @registro_proveedor.rut).first
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: @registro_proveedor.user_encargado, data: @registro_proveedor.id)
        tarea_previa = Tarea.where(codigo: 'PRO-008').first
        tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        tarea_pendiente.first.delete
      end

      if value == 2
        @registro_proveedor.update!(estado: 8)
        RegistroProveedorMailer.revision_negativa(@registro_proveedor).deliver_later
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea_pendiente = TareaPendiente.where(flujo_id: 1000).first
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

      if @registro_proveedor.estado == 'actualizado'
        @registro_proveedor.update!(fecha_revalidacion: value, estado: 'aprobado')
        RegistroProveedorMailer.revision_positiva(@registro_proveedor).deliver_now
      end
    @registro_proveedor.update!(fecha_revalidacion: value, estado: 'aprobado')

    end

    redirect_to root_path
    flash[:success] = "Registro enviado correctamente"
  end

  #PRO-009
  def evaluacion_proveedores
    if current_user.posee_rol_ascc?(Rol::REVISOR_PROVEEDORES)
      registro_proveedor = RegistroProveedor.where(estado: 'aprobado')
      registro_proveedor_con_notas = registro_proveedor.select { |f| f.nota_registro_proveedores.present? && f.calificado }
      @registro_proveedores = registro_proveedor_con_notas
    else
      redirect_to root_path
      flash[:success] = 'No tienes permiso para acceder a esta pagina'
    end
  end

  def clasificar_proveedores
    estados = params[:estado]
    estados_seleccionados = estados.select { |k, v| v.present? }

    estados_seleccionados.each do |k, v|
      key = k
      value = v.to_i
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(calificado: false)
      if value == 2
        @registro_proveedor.update!(estado: 6)
        RegistroProveedorMailer.rechazo_definitivo(@registro_proveedor).deliver_later
      elsif value == 3
        @registro_proveedor.update!(estado: 10)
      end
    end

    comentarios = params[:comentario]
    comentarios_seleccionados = comentarios.select { |k, v| v.present? }

    comentarios_seleccionados.each do |k, v|
      key = k
      value = v
      @registro_proveedor = RegistroProveedor.find(key)
      @registro_proveedor.update!(comentario_negativo: value)

      if @registro_proveedor.estado == 'calificacion_negativa'
        flujo = Flujo.where(id: 1000, contribuyente_id: 1000, tipo_instrumento_id: 26).first_or_create
        tarea = Tarea.where(codigo: 'PRO-010').first
        user = User.where(rut: @registro_proveedor.rut).first
        TareaPendiente.create(flujo_id: flujo.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: user.id)
        # tarea_previa = Tarea.where(codigo: 'PRO-009').first
        # tarea_pendiente = TareaPendiente.where(flujo_id: flujo.id, tarea_id: tarea_previa.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, data: @registro_proveedor.id)
        # tarea_pendiente.first.delete
      end
    end

    redirect_to root_path
    flash[:success] = "Registro enviado correctamente"

  end

  #PRO-010
  def enviar_carta_compromiso
    @registro_proveedor = RegistroProveedor.find(params[:id])
    @descargables_tarea = DescargableTarea.where(tarea_id: 110)
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

  def get_by_rut
    @user = User.find_by(rut: params[:rut])
    respond_to do |format|
      format.html
      format.json { render :json => @user}
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

  def send_message(tarea, user)
    u = User.find(user)
    mensajes = RegistroProveedorMensaje.where(tarea_id: tarea.id)
    mensajes.each do |mensaje|
      RegistroProveedorMensajeMailer.paso_de_tarea(@registro_proveedor, mensaje.asunto, mensaje.body, u).deliver_later
    end
  end

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
      :rut_institucion, :nombre_institucion, :tipo_contribuyente, :editar, :tipo_proveedor_id, :direccion_casa_matriz, :region_casa_matriz, :comuna_casa_matriz, :correlativo, :ciudad_casa_matriz, :contribuyente_id, :respuesta_comentario,
      :archivo_respuesta_rechazo, :comentario_directiva, :respuesta_comentario_directiva, :archivo_respuesta_rechazo_directiva, :fecha_aprobado, :fecha_actualizado, :archivo_aprobado_directiva, :archivo_aprobado_directiva_cache, :carta_compromiso, :carta_compromiso_cache,
      certificado_proveedores_attributes: [:id, :materia_sustancia_id, :actividad_economica_id,  :archivo_certificado, :archivo_certificado_cache, :_destroy], documento_registro_proveedores_attributes: [:id, :description, :archivo, :archivo_cache, :_destroy],
      certificado_proveedor_extras_attributes: [:id, :materia_sustancia_id, :actividad_economica_id, :archivo, :archivo_cache, :_destroy], documento_proveedor_extras_attributes: [:id, :description, :archivo, :archivo_cache, :_destroy])
  end

  def datos_header_no_signed
    if !user_signed_in?
      @header = ReporteriaDato.find_by(ruta: nil)
    end
  end
end
