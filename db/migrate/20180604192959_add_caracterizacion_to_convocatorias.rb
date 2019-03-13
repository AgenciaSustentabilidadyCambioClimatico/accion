class AddCaracterizacionToConvocatorias < ActiveRecord::Migration[5.1]
  def change
    add_column :convocatorias, :caracterizacion, :text
  end
end
