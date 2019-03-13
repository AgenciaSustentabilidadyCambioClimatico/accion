class AddFirmaFieldsToManifestacionDeIntereses < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :fecha_firma, :date
  	add_column :manifestacion_de_intereses, :direccion_firma, :string
  	add_column :manifestacion_de_intereses, :lat_firma, :decimal
  	add_column :manifestacion_de_intereses, :lng_firma, :decimal
  	add_column :manifestacion_de_intereses, :firmantes, :text
  	add_column :manifestacion_de_intereses, :archivo_firma, :json
  end
end
