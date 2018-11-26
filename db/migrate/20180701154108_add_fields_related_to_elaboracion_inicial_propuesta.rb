class AddFieldsRelatedToElaboracionInicialPropuesta < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :archivo_propuesta_elaboracion, :string
  	add_column :programa_proyecto_propuestas, :comentarios_observaciones_tecnicas, :text
  	add_column :programa_proyecto_propuestas, :archivo_observaciones_tecnicas, :string
  	add_column :programa_proyecto_propuestas, :fecha_observaciones_tecnicas, :date
  	add_column :programa_proyecto_propuestas, :resultado_observaciones_tecnicas, :integer
  end
end