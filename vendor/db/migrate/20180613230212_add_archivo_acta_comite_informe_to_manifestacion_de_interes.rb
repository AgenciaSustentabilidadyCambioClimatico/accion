class AddArchivoActaComiteInformeToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :archivo_acta_comite_informe, :string
  end
end
