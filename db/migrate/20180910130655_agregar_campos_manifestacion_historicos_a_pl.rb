class AgregarCamposManifestacionHistoricosAPl < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :fecha_manifestacion, :date, null: true
  	add_column :manifestacion_de_intereses, :documentos_historicos, :json, null: true
  	add_column :manifestacion_de_intereses, :texto_apl, :string, null: true
  end
end
