class AddSinMovimientosToRendicionesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendiciones_fpl, :sin_movimientos, :boolean
  end
end
