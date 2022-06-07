class AddUploadFieldsToManifestacionSeccion < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :estandar_certificable, :text
    add_column :manifestacion_de_intereses, :diagnostico_de_acuerdo_anterior, :text
    add_column :manifestacion_de_intereses, :informe_de_acuerdo_anterior, :text
  end
end
