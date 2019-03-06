class AddTimeStampsToEncuestaUserRespuesta < ActiveRecord::Migration[5.1]
  def change
  	  	# agrega los timestamps pero permite valores null
  	add_timestamps :encuesta_user_respuestas, null: true

	  # rellena los registros preexistentes
	  ahora = DateTime.now
	  EncuestaUserRespuesta.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :encuesta_user_respuestas, :created_at, false
	  change_column_null :encuesta_user_respuestas, :updated_at, false
  end
end
