class AddObservacionesPropuestaAcuerdoToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :observaciones_propuesta_acuerdo, :text
  end
end
