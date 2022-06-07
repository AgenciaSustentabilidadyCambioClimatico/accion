class AddAcuerdoPrevioConInformeIdToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :acuerdo_previo_con_informe_id, :integer
  end
end
