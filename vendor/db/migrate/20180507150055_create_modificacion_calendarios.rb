class CreateModificacionCalendarios < ActiveRecord::Migration[5.1]
  def change
    create_table :modificacion_calendarios do |t|
      t.integer :proyecto_id
      t.text :atributos_proyecto
      t.text :atributos_proyecto_actividades
      t.text :atributos_rendiciones

      t.timestamps
    end
    add_foreign_key :modificacion_calendarios, :proyectos
  end
end
