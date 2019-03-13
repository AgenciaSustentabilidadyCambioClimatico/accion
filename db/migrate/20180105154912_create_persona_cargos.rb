class CreatePersonaCargos < ActiveRecord::Migration[5.1]
  def change
    create_table :persona_cargos do |t|
      t.integer :persona_id, null: false
      t.integer :cargo_id, null: false
    end
    add_foreign_key :persona_cargos, :personas
    add_foreign_key :persona_cargos, :cargos
  end
end