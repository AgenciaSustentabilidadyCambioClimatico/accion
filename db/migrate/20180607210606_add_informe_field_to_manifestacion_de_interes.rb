class AddInformeFieldToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :informe, :text
  end
end
