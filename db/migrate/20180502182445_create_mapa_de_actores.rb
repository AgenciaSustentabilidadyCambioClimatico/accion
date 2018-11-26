class CreateMapaDeActores < ActiveRecord::Migration[5.1]
  def change
    create_table :mapa_de_actores do |t|
      t.integer :flujo_id, null: false
      t.integer :rol_id, null: false
      t.integer :persona_id, null: false
    end
    add_foreign_key :mapa_de_actores, :flujos
    add_foreign_key :mapa_de_actores, :roles
    add_foreign_key :mapa_de_actores, :personas
  end
end
