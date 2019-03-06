class EliminaResponsableElaboracionPropuestaToProgramaProyectoPropuesta < ActiveRecord::Migration[5.1]
  def up
  	remove_foreign_key :programa_proyecto_propuestas, column: :responsable_elaboracion_propuesta_y_seguimiento_id
  	remove_column :programa_proyecto_propuestas, :responsable_elaboracion_propuesta_y_seguimiento_id
  end
  def down
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :responsable_elaboracion_propuesta_y_seguimiento_id
  end
end