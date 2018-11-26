class AddEstadoToConvocatorias < ActiveRecord::Migration[5.1]
  def up
    add_column :convocatorias, :terminada, :boolean, default: false
  end
  def down
  	remove_column :convocatorias, :terminada, :boolean
  end
end
