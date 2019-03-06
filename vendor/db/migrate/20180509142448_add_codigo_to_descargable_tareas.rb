class AddCodigoToDescargableTareas < ActiveRecord::Migration[5.1]
  def up
    add_column :descargable_tareas, :nombre, :string, null: true
  	add_column :descargable_tareas, :codigo, :string, limit: 15, null: true
  	add_column :descargable_tareas, :archivo, :string
  	add_column :descargable_tareas, :subido, :boolean, default: false, null: false
  	change_column :descargable_tareas, :tarea_id, :integer, null: false
  	change_column :descargable_tareas, :formato, 'integer USING CAST(formato AS integer)', null: false
  	add_index :descargable_tareas, :codigo, unique: true
  end

  def down
  	remove_index :descargable_tareas, :codigo
    remove_column :descargable_tareas, :nombre, :string
  	remove_column :descargable_tareas, :codigo, :string
  	remove_column :descargable_tareas, :subido, :boolean
  	remove_column :descargable_tareas, :archivo, :string
  	change_column :descargable_tareas, :tarea_id, :integer, null: true
  	change_column :descargable_tareas, :formato, 'character varying USING CAST(formato AS character varying)', null: true
  end
end