class AgregaTimeStampsToEstablecimientoContribuyente < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :establecimiento_contribuyentes, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  EstablecimientoContribuyente.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :establecimiento_contribuyentes, :created_at, false
	  change_column_null :establecimiento_contribuyentes, :updated_at, false
  end
end
