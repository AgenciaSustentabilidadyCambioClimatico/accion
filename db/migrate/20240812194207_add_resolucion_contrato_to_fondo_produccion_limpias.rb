class AddResolucionContratoToFondoProduccionLimpias < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :archivo_resolucion, :string
    add_column :fondo_produccion_limpia, :archivo_contrato, :string
  end
end
