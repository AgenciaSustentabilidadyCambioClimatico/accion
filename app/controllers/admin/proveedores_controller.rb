class Admin::ProveedoresController < ApplicationController
  before_action :authenticate_user!, except: [:index, :get_apls_registro]
  before_action :set_variables_del_usuario
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy, :establecimientos]
  before_action :set_new_contribuyente, only: [:new, :edit, :create, :update]
  before_action :get_apls_registro, only: [:get_apls_registro]
  before_action :set_registro_proveedor, only: [:new, :create, :edit, :update]

  def index
    @proveedores = Proveedor.includes([:proveedor_tipo_proveedores]).all
    # DZC calcula la evaluación promedio del proveedor
    @proveedores.each do |p|
      p.calcula_evaluacion
    end
    @proveedor = Proveedor.new
    @registro_proveedores = RegistroProveedor.where(estado: 4).order("nombre DESC")
    @registro_vencido = RegistroProveedor.where(estado: 8).order("nombre DESC")
  end

  def new
    @proveedor = Proveedor.new
    @registro_proveedor = RegistroProveedor.new
    @registro_proveedor.certificado_proveedores.build
    @registro_proveedor.documento_registro_proveedores.build
  end

  def edit
  end

  # def create
  #   @proveedor = Proveedor.new(proveedor_params)
  #   respond_to do |format|
  #     if @proveedor.save
  #       format.js {
  #         flash.now[:success] = 'Proveedor correctamente creado.'
  #         @proveedor = Proveedor.new
  #       }
  #       format.html { redirect_to edit_admin_proveedor_url(@proveedor), notice: 'Proveedor correctamente creado.' }
  #     else
  #       format.html { render :new }
  #       format.js
  #     end
  #   end
  # end

  def create
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
        RegistroProveedor::AdminCreateService.new(@registro_proveedor, registro_proveedores_params).perform
        @registro_proveedor.update(fecha_aprobado: params[:registro_proveedor][:fecha_aprobado])
        format.js {
          render js: "window.location='#{root_path}'"
          flash[:success] = "Registro enviado correctamente"
        }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @proveedor.update(proveedor_params)
        format.js { flash.now[:success] = 'Proveedor correctamente actualizada.' }
        format.html { redirect_to edit_admin_proveedor_url(@proveedor), notice: 'Proveedor correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @proveedor.destroy
    redirect_to admin_proveedores_url, notice: 'Proveedor correctamente eliminado.'
  end

  def establecimientos
    respond_to do |format|
      @establecimientos = @proveedor.contribuyente.determina_establecimientos

      format.js {}
      format.html {}
    end
  end

  def get_apls_registro
    respond_to do |format|
      @registro_proveedor = RegistroProveedor.find(params[:id])
      @registro = RegistroProveedor.find(params[:id])
      if @registro.tipo_proveedor_id == 1
         @cv = DocumentoRegistroProveedor.where(registro_proveedor_id: @registro.id, description: "Curriculum Vitae").first if current_user
      else
        @cv = DocumentoRegistroProveedor.where(registro_proveedor_id: @registro.id, description: "Curriculum Vitae").first
      end
      @experiencias = CertificadoProveedor.where(registro_proveedor_id: @registro.id)
      @resolucion = @registro.archivo_aprobado_directiva
      @apls = @registro.get_apl
      format.js {}
      format.json { render :json => @apls }
      format.html { render :json => @apls } 
      format.any { render :json => @apls } 
    end
  end

  private

  def set_variables_del_usuario
    @tipos_proveedor = TipoProveedor.all
    @regiones = Region.all
  end

  def set_proveedor
    @proveedor = Proveedor.find(params[:id])
    contribuyente = @proveedor.contribuyente
    @proveedor.rut_contribuyente = contribuyente.rut_completo
    @proveedor.nombre_contribuyente = contribuyente.razon_social
    # DZC se agregan los establecimientos del proveedor
  end

  def set_new_contribuyente
    @contribuyente = Contribuyente.new
    @contribuyentes = []
  end

  def proveedor_params
    params.require(:proveedor).permit(
      :contribuyente_id,
      :tipo_instrumento_id,
      :materia_sustancia_id,
      :clasificacion_id,
      :alcance_id,
      :rut_contribuyente,
      :nombre_contribuyente,
      proveedor_tipo_proveedores_attributes: [
        :id,
        :tipo_proveedor_id,
        :_destroy
      ]
    )
  end

  def registro_proveedores_params
    params.require(:registro_proveedor).permit(:rut, :nombre, :apellido, :email, :telefono, :profesion, :direccion, :region, :comuna, :ciudad, :asociar_institucion, :tipo_contribuyente_id, :terminos_y_servicion,
      :rut_institucion, :nombre_institucion, :tipo_contribuyente, :tipo_proveedor_id, :direccion_casa_matriz, :correlativo, :region_casa_matriz, :comuna_casa_matriz, :ciudad_casa_matriz, :contribuyente_id, :respuesta_comentario,
      :archivo_respuesta_rechazo, :comentario_directiva, :respuesta_comentario_directiva, :archivo_respuesta_rechazo_directiva, :fecha_aprobado, :fecha_actualizado, :archivo_aprobado_directiva, :archivo_aprobado_directiva_cache,
      certificado_proveedores_attributes: [:id, :materia_sustancia_id, :actividad_economica_id, :archivo_certificado, :archivo_certificado_cache, :_destroy], documento_registro_proveedores_attributes: [:id, :description, :archivo, :archivo_cache, :_destroy],
      certificado_proveedor_extras_attributes: [:id, :materia_sustancia_id, :actividad_economica_id, :archivo, :archivo_cache, :_destroy], documento_proveedor_extras_attributes: [:id, :description, :archivo, :archivo_cache, :_destroy])
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
end
