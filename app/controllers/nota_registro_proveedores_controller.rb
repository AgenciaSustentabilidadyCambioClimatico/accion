class NotaRegistroProveedoresController < ApplicationController
  # 1. Bloqueo inmediato para usuarios sin sesión activa
  before_action :authenticate_user!
  before_action :set_nota_registro_proveedor, only: %i[edit update]

  def index
    authorize NotaRegistroProveedor
    @nota_registro_proveedores = policy_scope(NotaRegistroProveedor)
  end

  def edit
    authorize @nota_registro_proveedor, :evaluar?
  end

  def update
    authorize @nota_registro_proveedor, :evaluar?

    if @nota_registro_proveedor.update(nota_registro_proveedor_params)
      flash[:success] = "Nota actualizada correctamente"
      redirect_to root_path
    else
      render :edit
    end
  end

  def evaluacion
    # Autoriza la acción masiva sobre el recurso
    authorize NotaRegistroProveedor, :evaluar?

    notas = params[:nota]
    if notas.blank?
      redirect_to root_path, alert: "No se enviaron notas para evaluar"
      return
    end

    notas_seleccionados = notas.select { |_k, v| v.present? }

    ActiveRecord::Base.transaction do
      notas_seleccionados.each do |k, v|
        @nota = NotaRegistroProveedor.find(k)
        @registro_proveedor = @nota.registro_proveedor

        @nota.update!(nota: v.to_i)
        @registro_proveedor.update!(calificado: true)
      end
    end

    flash[:success] = "Nota enviada correctamente"
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Error al guardar la evaluación: #{e.message}"
    redirect_to root_path
  end

  private

  def set_nota_registro_proveedor
    @nota_registro_proveedor = NotaRegistroProveedor.find(params[:id])
  end

  def nota_registro_proveedor_params
    params.require(:nota_registro_proveedor).permit(:nota)
  end
end