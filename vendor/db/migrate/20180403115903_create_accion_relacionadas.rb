class CreateAccionRelacionadas < ActiveRecord::Migration[5.1]
  def change
    create_table :accion_relacionadas do |t|
      t.integer :accion_id, null: false
      t.integer :accion_relacionada_id, null: false
      t.text :descripcion, null: false
    end
    add_foreign_key :accion_relacionadas, :acciones
    add_foreign_key :accion_relacionadas, :acciones, column: :accion_relacionada_id
  end
end