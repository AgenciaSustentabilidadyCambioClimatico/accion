class AddFechaHoraToConvocatorias < ActiveRecord::Migration[5.1]
  def change
    add_column :convocatorias, :fecha_hora, :datetime
  end
end
