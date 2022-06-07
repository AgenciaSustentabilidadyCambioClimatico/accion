class AddColumnsToTraspasoInstrumentos < ActiveRecord::Migration[5.1]
  def change
    add_column :traspaso_instrumentos, :cambios_mapa_de_actores, :text, null: true
    add_column :traspaso_instrumentos, :cambios_tareas_pendientes, :text, null: true
  end
end
