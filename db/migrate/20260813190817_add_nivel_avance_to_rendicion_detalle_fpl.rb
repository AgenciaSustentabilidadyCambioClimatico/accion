class AddNivelAvanceToRendicionDetalleFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_detalles_fpl, :nivel_avance, :integer
  end
end
