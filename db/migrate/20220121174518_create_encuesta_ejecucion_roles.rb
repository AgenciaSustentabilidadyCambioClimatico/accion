class CreateEncuestaEjecucionRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :encuesta_ejecucion_roles do |t|
      t.references :tarea, foreign_key: true
      t.references :rol, foreign_key: true
      t.timestamps
    end
  end
end
