class AgregaTimeStampToAuditorias < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :auditorias, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  Auditoria.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :auditorias, :created_at, false
	  change_column_null :auditorias, :updated_at, false
  end
end
