class CreateProyectoActividades < ActiveRecord::Migration[5.1]
  def change
    create_table :proyecto_actividades do |t|
    	t.integer :proyecto_id
    	t.string :nombre
    	t.integer :duracion
    	t.date :fecha_finalizacion
    	t.date :fecha_realizacion_compromiso
    end
  end
end
