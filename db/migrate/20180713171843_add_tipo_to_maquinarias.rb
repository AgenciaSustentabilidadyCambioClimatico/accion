class AddTipoToMaquinarias < ActiveRecord::Migration[5.1]
  def change
  	add_column :maquinarias, :tipo, :text
  	add_column :maquinarias, :archivos_imagen, :json
  end
end
