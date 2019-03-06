class CreateEncuestaUserRespuestas < ActiveRecord::Migration[5.1]
  def change
    create_table :encuesta_user_respuestas do |t|
      t.integer :encuesta_id, null: false
      t.integer :user_id, null: false
      t.integer :pregunta_id, null: false
      t.text :respuesta, null: false
    end
    add_foreign_key :encuesta_user_respuestas, :encuestas
    add_foreign_key :encuesta_user_respuestas, :users
    add_foreign_key :encuesta_user_respuestas, :preguntas
  end
end