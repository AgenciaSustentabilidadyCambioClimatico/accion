class CambioManifestacionNombreInstrumento < ActiveRecord::Migration[5.1]
  def change
  	remove_column :manifestacion_de_intereses, :instrumentos_relacionados
  	add_column :manifestacion_de_intereses, :instrumentos_relacionados_historico, :text, null: true
  end
end
