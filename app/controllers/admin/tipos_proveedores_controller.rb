class Admin::TiposProveedoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tipo_proveedor, only: [:show, :edit, :update, :destroy]

  def index
    @tipo_proveedores = TipoProveedor.order(id: :desc).all
    @tipo_proveedor  = TipoProveedor.new
  end

  def new
    @tipo_proveedor = TipoProveedor.new
  end

  def edit
  end

  def create
    @tipo_proveedor = TipoProveedor.new(tipo_proveedor_params)
    respond_to do |format|
      if @tipo_proveedor.save
        format.js { 
          flash.now[:success] = 'Tipo proveedor correctamente creado.'
          @tipo_proveedor = TipoProveedor.new
        }
        format.html { redirect_to edit_admin_tipo_proveedor_url(@tipo_proveedor), notice: 'Tipo proveedor correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @tipo_proveedor.update(tipo_proveedor_params)
        format.js { flash.now[:success] = 'Tipo proveedor correctamente actualizada.' }
        format.html { redirect_to edit_admin_tipo_proveedor_url(@tipo_proveedor), notice: 'Tipo proveedor correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @tipo_proveedor.destroy
    redirect_to admin_tipos_proveedores_url, notice: 'Tipo proveedor correctamente eliminado.'
  end

  private
    def set_tipo_proveedor
      @tipo_proveedor = TipoProveedor.find(params[:id])
    end

    def tipo_proveedor_params
      params.require(:tipo_proveedor).permit(
        :nombre,
        :descripcion,
        :solo_asignable_por_ascc
      )
    end
end