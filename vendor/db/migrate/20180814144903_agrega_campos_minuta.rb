class AgregaCamposMinuta < ActiveRecord::Migration[5.1]
  def change
  	add_column :minutas, :mensaje_encabezado, :text, null: true
  	add_column :minutas, :mensaje_cuerpo, :text, null: true
  end
end
