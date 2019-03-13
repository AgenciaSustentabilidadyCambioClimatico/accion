class CambioTipoPlazoEjecucionPpp < ActiveRecord::Migration[5.1]
  def change
  	# change_column :programa_proyecto_propuestas, :plazo_ejecucion_legal, :date

  	remove_column :programa_proyecto_propuestas, :plazo_ejecucion_legal
  	add_column :programa_proyecto_propuestas, :plazo_ejecucion_legal, :date, null: true
  end
end
