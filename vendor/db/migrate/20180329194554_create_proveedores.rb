class CreateProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :proveedores do |t|
      t.integer :contribuyente_id, null: false
      t.integer :tipo_instrumento_id
      t.integer :materia_sustancia_id
      t.integer :clasificacion_id
      t.integer :alcance_id
    end
    add_foreign_key :proveedores, :contribuyentes
    add_foreign_key :proveedores, :tipo_instrumentos
    add_foreign_key :proveedores, :materia_sustancias
    add_foreign_key :proveedores, :clasificaciones
    add_foreign_key :proveedores, :alcances
  end
end