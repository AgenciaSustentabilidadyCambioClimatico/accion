class Admin::ProveedoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables_del_usuario
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy, :establecimientos]
  before_action :set_new_contribuyente, only: [:new, :edit, :create, :update]
  before_action :get_apls_registro, only: [:get_apls_registro]

  def index
    @proveedores = Proveedor.includes([:proveedor_tipo_proveedores]).order(id: :desc).all
    #DZC calcula la evaluación promedio del proveedor
    @proveedores.each do |p|
      p.calcula_evaluacion
    end
    @proveedor  = Proveedor.new
    @registro_proveedores = RegistroProveedor.where(estado: 4)
  end

  def new
    @proveedor = Proveedor.new
  end

  def edit
  end

  def create
    @proveedor = Proveedor.new(proveedor_params)
    respond_to do |format|
      if @proveedor.save
        format.js { 
          flash.now[:success] = 'Proveedor correctamente creado.'
          @proveedor = Proveedor.new
        }
        format.html { redirect_to edit_admin_proveedor_url(@proveedor), notice: 'Proveedor correctamente creado.' }
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
      
      format.js { }
      format.html { }
    end
  end
  def get_apls_registro
    respond_to do |format|
      registro = RegistroProveedor.find(params[:id])
      @cv = DocumentoRegistroProveedor.where(registro_proveedor_id: registro.id).first
      @experiencias = CertificadoProveedor.where(registro_proveedor_id: registro.id)
      @apls = registro.get_apl
      format.js {}
      format.json { render :json => @apls}
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
      #DZC se agregan los establecimientos del proveedor
    end


    def set_new_contribuyente
      @contribuyente    = Contribuyente.new
      @contribuyentes  = []
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
end