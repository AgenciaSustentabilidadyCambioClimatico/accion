class AddCampoComentariosYObservacionesNegociacionAcuerdoToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :comentarios_y_observaciones_negociacion_acuerdo, :text
    add_column :manifestacion_de_intereses, :fecha_termino_negociacion, :timestamp
  end
end
