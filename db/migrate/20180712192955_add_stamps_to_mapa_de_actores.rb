class AddStampsToMapaDeActores < ActiveRecord::Migration[5.1]
  def change
  	  	# agrega los timestamps pero permite valores null
  	add_timestamps :mapa_de_actores, null: true

	  # rellena los registros preexistentes
	  ahora = DateTime.now
	  MapaDeActor.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :mapa_de_actores, :created_at, false
	  change_column_null :mapa_de_actores, :updated_at, false
  end
end
