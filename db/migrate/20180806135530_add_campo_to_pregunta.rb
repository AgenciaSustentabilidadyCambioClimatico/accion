class AddCampoToPregunta < ActiveRecord::Migration[5.1]
  def change
  	add_column :preguntas, :base, :boolean, default: false, null: true
  	Pregunta.update_all(base: false)
  	add_timestamps :preguntas, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  Pregunta.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :preguntas, :created_at, false
	  change_column_null :preguntas, :updated_at, false
  end
end
