class AddUnidadMedidaToGasto < ActiveRecord::Migration[5.1]
  def change
    add_column :gastos, :unidad_medida, :integer
  end
end
