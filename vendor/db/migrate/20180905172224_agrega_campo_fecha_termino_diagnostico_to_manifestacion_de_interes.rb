class AgregaCampoFechaTerminoDiagnosticoToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :diagnostico_fecha_termino, :timestamp
  end
end
