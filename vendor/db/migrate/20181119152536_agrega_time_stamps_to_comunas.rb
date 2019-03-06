class AgregaTimeStampsToComunas < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :comunas, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  Comuna.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :comunas, :created_at, false
	  change_column_null :comunas, :updated_at, false
  end
end
