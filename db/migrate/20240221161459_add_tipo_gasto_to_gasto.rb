class AddTipoGastoToGasto < ActiveRecord::Migration[5.1]
  def change
    add_column :gastos, :tipo_gasto, :integer
  end
end
