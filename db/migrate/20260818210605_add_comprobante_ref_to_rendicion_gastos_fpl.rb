class AddComprobanteRefToRendicionGastosFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_gastos_fpl, :comprobante_ref, :string
  end
end
