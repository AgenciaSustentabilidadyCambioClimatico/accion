class CreateAcciones < ActiveRecord::Migration[5.1]
  def change
    create_table :acciones do |t|
      t.integer :meta_id
      t.string :nombre, null: false
      t.text :descripcion, null: false
      t.boolean :debe_asociar_materia_sustancia, null: false, default: true
      t.text :medio_de_verificacion_generico, null: false
    end
    add_foreign_key :acciones, :clasificaciones, column: :meta_id
  end
end