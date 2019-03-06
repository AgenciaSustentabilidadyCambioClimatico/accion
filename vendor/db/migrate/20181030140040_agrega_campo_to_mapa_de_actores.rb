class AgregaCampoToMapaDeActores < ActiveRecord::Migration[5.1]
  def change
  	add_column :mapa_de_actores, :persona_cargo_id, :integer, null: true
  	add_foreign_key :mapa_de_actores, :persona_cargos, column: :persona_cargo_id
  end
end
