class CreateCampoTareas < ActiveRecord::Migration[5.1]
  def change
    create_table :campo_tareas do |t|
    	t.references :campo, foreign_key: true
			t.references :tarea, foreign_key: true
			t.timestamps null: false
    end
  end
end
