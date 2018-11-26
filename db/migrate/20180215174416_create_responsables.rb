class CreateResponsables < ActiveRecord::Migration[5.1]
  def change
    create_table :responsables do |t|
      t.integer :tipo_instrumento_id, null: false
      t.integer :rol_id, null: false
      t.integer :cargo_id
      t.integer :contribuyente_id
      t.integer :actividad_economica_id
      t.integer :tipo_contribuyente_id
    end
    add_foreign_key :responsables, :tipo_instrumentos
    add_foreign_key :responsables, :roles
    add_foreign_key :responsables, :cargos
    add_foreign_key :responsables, :contribuyentes
    add_foreign_key :responsables, :actividad_economicas
    add_foreign_key :responsables, :tipo_contribuyentes
  end
end