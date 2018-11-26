class ModificaCamposFirmaToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	rename_column :manifestacion_de_intereses, :fecha_firma, :firma_fecha
  	rename_column :manifestacion_de_intereses, :direccion_firma, :firma_direccion 
  	rename_column :manifestacion_de_intereses, :lat_firma, :firma_lat
  	rename_column :manifestacion_de_intereses, :lng_firma, :firma_lng
  	rename_column :manifestacion_de_intereses, :firmantes, :firma_firmantes
  	rename_column :manifestacion_de_intereses, :archivo_firma, :firma_archivo
  end
end
