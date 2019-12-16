class AddFieldComentariosCifrasToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :comentarios_cifras, :text
  end
end
