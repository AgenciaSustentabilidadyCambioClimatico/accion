class AddTareaPendienteToEncuestaUserRespuestas < ActiveRecord::Migration[5.1]
  def change
    add_reference :encuesta_user_respuestas, :tarea_pendiente, foreign_key: true
  end
end
