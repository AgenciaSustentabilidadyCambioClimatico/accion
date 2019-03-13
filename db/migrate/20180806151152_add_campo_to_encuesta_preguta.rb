class AddCampoToEncuestaPreguta < ActiveRecord::Migration[5.1]
  def change
  	add_column :encuesta_preguntas, :base, :boolean, default: false, null: true
  	EncuestaPregunta.update_all(base: true)
  	change_column_null :encuesta_preguntas, :base, false
  	change_column :encuesta_preguntas, :obligatorio, :boolean, default: false, null: false
  	add_timestamps :encuesta_preguntas, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  EncuestaPregunta.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :encuesta_preguntas, :created_at, false
	  change_column_null :encuesta_preguntas, :updated_at, false
  end
end
