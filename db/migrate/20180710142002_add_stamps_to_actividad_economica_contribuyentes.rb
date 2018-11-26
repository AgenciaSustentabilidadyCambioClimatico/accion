class AddStampsToActividadEconomicaContribuyentes < ActiveRecord::Migration[5.1]
  def change
  	# agrega los timestamps pero permite valores null
  	add_timestamps :actividad_economica_contribuyentes, null: true

	  # rellena los registros preexistentes
	  ahora = DateTime.now
	  ActividadEconomicaContribuyente.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :actividad_economica_contribuyentes, :created_at, false
	  change_column_null :actividad_economica_contribuyentes, :updated_at, false
  end
end
