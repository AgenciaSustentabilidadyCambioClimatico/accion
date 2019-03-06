class AddEntregablesDiagnosticoFieldsToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :user_carga_actores_id, :integer
    add_column :manifestacion_de_intereses, :comentarios_y_observaciones_documento_diagnosticos, :text, null: true
    add_column :manifestacion_de_intereses, :comentarios_y_observaciones_propuesta_de_acuerdos, :text, null: true
  end

end
