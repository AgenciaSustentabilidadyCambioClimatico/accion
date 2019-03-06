class AgregaTimeStampsToSetMetasAccion < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :set_metas_acciones, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  SetMetasAccion.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :set_metas_acciones, :created_at, false
	  change_column_null :set_metas_acciones, :updated_at, false
  end
end
