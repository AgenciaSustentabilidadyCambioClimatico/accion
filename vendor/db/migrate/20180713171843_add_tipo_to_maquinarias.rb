class AddTipoToMaquinarias < ActiveRecord::Migration[5.1]
  def change
  	add_column :maquinarias, :tipo, :text
  	add_column :maquinarias, :archivo_imagen, :json
  end
end
