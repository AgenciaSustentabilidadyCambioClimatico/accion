class AddFechaHoraToMinutas < ActiveRecord::Migration[5.1]
  def change
    add_column :minutas, :fecha_hora, :datetime
  end
end
