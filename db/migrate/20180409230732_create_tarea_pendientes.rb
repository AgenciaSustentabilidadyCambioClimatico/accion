class CreateTareaPendientes < ActiveRecord::Migration[5.1]
  def change
    create_table :tarea_pendientes do |t|
      t.integer :flujo_id, null: false
      t.integer :tarea_id, null: false
      t.integer :estado_tarea_pendiente_id, null: false
      t.integer :user_id, null: false
      t.text :data
      t.text :resultado
    end
    add_foreign_key :tarea_pendientes, :flujos
    add_foreign_key :tarea_pendientes, :tareas
    add_foreign_key :tarea_pendientes, :estado_tarea_pendientes
    add_foreign_key :tarea_pendientes, :users
  end
end
