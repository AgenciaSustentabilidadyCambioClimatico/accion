class AddFechaResolucionToFondoProduccionLimpias < ActiveRecord::Migration[6.0]
  def change
    add_column :fondo_produccion_limpia, :fecha_resolucion, :date
  end
end
