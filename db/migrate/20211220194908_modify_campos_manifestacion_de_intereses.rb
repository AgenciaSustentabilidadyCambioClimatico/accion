class ModifyCamposManifestacionDeIntereses < ActiveRecord::Migration[5.1]
  def change
    change_column :manifestacion_de_intereses, :numero_empresas, :text
    change_column :manifestacion_de_intereses, :produccion, :text
    change_column :manifestacion_de_intereses, :ventas, :text
    change_column :manifestacion_de_intereses, :porcentaje_exportaciones, :text
    change_column :manifestacion_de_intereses, :numero_trabajadores, :text
  end
end
