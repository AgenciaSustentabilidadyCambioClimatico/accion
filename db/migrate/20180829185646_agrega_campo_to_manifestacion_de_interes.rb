class AgregaCampoToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :comentarios_y_observaciones_termino_acuerdo, :text, null: true
  	add_column :manifestacion_de_intereses, :fecha_termino_acuerdo, :timestamp
  end
end
