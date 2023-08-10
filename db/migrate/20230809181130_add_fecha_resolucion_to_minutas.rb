class AddFechaResolucionToMinutas < ActiveRecord::Migration[5.1]
  def change
    add_column :minutas, :fecha_resolucion, :datetime
  end
end
