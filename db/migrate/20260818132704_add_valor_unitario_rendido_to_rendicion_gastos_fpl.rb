class AddValorUnitarioRendidoToRendicionGastosFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_gastos_fpl, :valor_unitario_rendido, :decimal
  end
end
