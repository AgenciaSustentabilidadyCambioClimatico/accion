class AddCamposAvanzadosToRendicionDetalleFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_detalles_fpl, :fecha_inicio, :date
    add_column :rendicion_detalles_fpl, :fecha_termino, :date
  end
end
