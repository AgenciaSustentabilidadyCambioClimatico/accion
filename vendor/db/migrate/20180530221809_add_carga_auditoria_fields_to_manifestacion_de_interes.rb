class AddCargaAuditoriaFieldsToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :archivo_carga_auditoria, :string
  end
end
