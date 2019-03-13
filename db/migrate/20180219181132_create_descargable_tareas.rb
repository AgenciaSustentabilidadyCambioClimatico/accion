class CreateDescargableTareas < ActiveRecord::Migration[5.1]
  def change
    create_table :descargable_tareas do |t|
      t.integer :tarea_id
      t.integer :formato
      t.text :contenido
    end
    add_foreign_key :descargable_tareas, :tareas
  end
end