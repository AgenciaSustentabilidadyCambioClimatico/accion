class AgregarCamposPpfParaHistoricos < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :fecha_elaboracion_propuesta, :date, null: true
  	add_column :programa_proyecto_propuestas, :fecha_carta_de_apoyo, :date, null: true
  	add_column :programa_proyecto_propuestas, :documento_productos_resultados, :string, null: true
  end
end
