class AddCampoToEncuesta < ActiveRecord::Migration[5.1]
  def change
    add_column :encuestas, :base, :boolean, default: false, null: true
    Encuesta.update_all(base: false)
    change_column_null :encuestas, :base, false
  	change_column :encuestas, :solo_dias_habiles, :boolean, default: false
  	add_timestamps :encuestas, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  Encuesta.update_all(created_at: ahora, updated_at: ahora)
	  # devuelve la condición not null
	  change_column_null :encuestas, :created_at, false
	  change_column_null :encuestas, :updated_at, false
  end
end
