class AddDireccionToListadoActoresTemporal < ActiveRecord::Migration[6.0]
  def change
    add_column :listado_actores_temporals, :direccion, :string
  end
end
