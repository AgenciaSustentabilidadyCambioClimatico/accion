class AgregaTareaCodigoToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :tarea_codigo, :text, null: true
  end
end
