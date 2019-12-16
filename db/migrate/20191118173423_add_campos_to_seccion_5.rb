class AddCamposToSeccion < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :detalle_de_localizacion, :text
    add_column :manifestacion_de_intereses, :detalle_de_alternativa_de_instalacion, :text
  end
end
