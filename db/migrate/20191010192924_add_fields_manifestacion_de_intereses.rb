class AddFieldsManifestacionDeIntereses < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :acuerdo_de_alcance_nacional, :boolean
  end
end
