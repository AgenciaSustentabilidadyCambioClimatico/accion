class AgregarMapaDeActoresData < ActiveRecord::Migration[5.1]
  def up
  	add_column :manifestacion_de_intereses, :mapa_de_actores_data, :text, null: true
  	add_column :manifestacion_de_intereses, :comentarios_y_observaciones_actualizacion_mapa_de_actores, :text, null: true
  	rename_column :manifestacion_de_intereses, :mapa_de_actores, :mapa_de_actores_archivo
  end

  def down
  	remove_column :manifestacion_de_intereses, :mapa_de_actores_data
  	remove_column :manifestacion_de_intereses, :comentarios_y_observaciones_actualizacion_mapa_de_actores
  	rename_column :manifestacion_de_intereses, :mapa_de_actores_archivo, :mapa_de_actores
  end
end
