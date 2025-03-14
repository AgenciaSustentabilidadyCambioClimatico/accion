class AddCodigoCiiuv4ToListadoActoresTemporal < ActiveRecord::Migration[6.0]
  def change
    add_column :listado_actores_temporals, :codigo_ciiuv4, :string
  end
end
