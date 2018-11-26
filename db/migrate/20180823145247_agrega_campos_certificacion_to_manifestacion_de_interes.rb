class AgregaCamposCertificacionToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :ceremonia_certificacion_fecha, :date
  	add_column :manifestacion_de_intereses, :ceremonia_certificacion_direccion, :string
  	add_column :manifestacion_de_intereses, :ceremonia_certificacion_lat, :decimal
  	add_column :manifestacion_de_intereses, :ceremonia_certificacion_lng, :decimal
  	add_column :manifestacion_de_intereses, :ceremonia_certificacion_firmantes, :text
  	add_column :manifestacion_de_intereses, :ceremonia_certificacion_archivo, :json
  end
end
