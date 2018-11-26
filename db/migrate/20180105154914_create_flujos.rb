class CreateFlujos < ActiveRecord::Migration[5.1]
  def change
    create_table :flujos do |t|
      t.integer :contribuyente_id, null: false
      t.integer :tipo_instrumento_id, null: false
      t.integer :proyecto_id, null: true
      t.timestamps
    end
    add_foreign_key :flujos, :contribuyentes
    add_foreign_key :flujos, :tipo_instrumentos
  end
end