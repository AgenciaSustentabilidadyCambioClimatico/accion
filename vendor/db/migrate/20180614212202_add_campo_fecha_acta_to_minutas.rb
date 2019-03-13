class AddCampoFechaActaToMinutas < ActiveRecord::Migration[5.1]
  def change
    add_column :minutas, :fecha_acta, :timestamp
  end
end
