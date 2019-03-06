class AddFieldsRelatedToRevisionPropuesta < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :secciones_observadas_revision, :text
  	add_column :programa_proyecto_propuestas, :resultado_de_la_revision, :integer
  	add_column :programa_proyecto_propuestas, :actual_respuesta_proponente_revision, :text
  	add_column :programa_proyecto_propuestas, :actual_observaciones_y_comentarios_revision, :text
    add_column :programa_proyecto_propuestas, :historia_respuesta_proponente_revision, :text
    add_column :programa_proyecto_propuestas, :historia_observaciones_y_comentarios_revision, :text
  	add_column :programa_proyecto_propuestas, :responsable_coordinacion_postulacion_y_seguimiento_id, :integer
  	add_column :programa_proyecto_propuestas, :responsable_elaboracion_propuesta_y_seguimiento_id, :integer
    add_column :programa_proyecto_propuestas, :revisada, :boolean, default: false
    add_column :programa_proyecto_propuestas, :resuelta, :boolean, default: false
    add_column :programa_proyecto_propuestas, :documento_proponente_revision, :text

  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :responsable_coordinacion_postulacion_y_seguimiento_id
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :responsable_elaboracion_propuesta_y_seguimiento_id
  end
end
