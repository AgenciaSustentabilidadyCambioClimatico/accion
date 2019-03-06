class CambiosToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	rename_column :manifestacion_de_intereses, :comentarios_y_observaciones_propuesta_de_acuerdos, :comentarios_y_observaciones_set_metas_acciones
  end
end
