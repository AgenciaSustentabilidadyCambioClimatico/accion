class AgregarCamposIntrumentosRelacionados < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :instrumentos_relacionados, :text, null: true
  	add_column :proyectos, :instrumentos_relacionados, :text, null: true
  end
end
