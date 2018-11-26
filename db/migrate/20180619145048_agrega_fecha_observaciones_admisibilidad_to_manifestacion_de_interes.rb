class AgregaFechaObservacionesAdmisibilidadToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :fecha_observaciones_admisibilidad, :timestamp
  end
end
