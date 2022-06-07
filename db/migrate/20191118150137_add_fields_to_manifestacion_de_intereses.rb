class AddFieldsToManifestacionDeIntereses < ActiveRecord::Migration[5.1]
  def change

    add_column :manifestacion_de_intereses, :sucursal_ligada, :integer
    add_column :manifestacion_de_intereses, :justificacion_de_seleccion, :text
    add_column :manifestacion_de_intereses, :registro_en_linea, :text
    
  end
end
