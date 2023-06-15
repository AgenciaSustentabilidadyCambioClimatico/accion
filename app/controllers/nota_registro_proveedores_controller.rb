class NotaRegistroProveedoresController < ApplicationController
  before_action :set_nota_registro_proveedor, only: %i[edit update]
  def index
    @nota_registro_proveedores = NotaRegistroProveedor.all
  end

  def edit; end

  def evaluacion
    notas = params[:nota]
    notas_seleccionados = notas.select { |k, v| v.present? }

    notas_seleccionados.each do |k, v|
      key = k
      value = v.to_i
      @nota = NotaRegistroProveedor.find(key)
      @nota.update!(nota: value)
    end
    redirect_to root_path
    flash[:success] = 'Nota enviada correctamente'
  end

  private

  def set_nota_registro_proveedor
    @nota_registro_proveedor = NotaRegistroProveedor.find(params[:id])
  end

  def nota_registro_proveedor_params
    params.require(:nota_registro_proveedor).permit(:nota)
  end
end
