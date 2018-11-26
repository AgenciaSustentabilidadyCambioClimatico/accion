class CreateEncuestaPreguntas < ActiveRecord::Migration[5.1]
  def change
    create_table :encuesta_preguntas do |t|
      t.integer :encuesta_id, null: false
      t.integer :pregunta_id, null: false
      t.integer :orden, null: false, default: 0
      t.boolean :obligatorio, null: false, default: true
    end
    add_foreign_key :encuesta_preguntas, :encuestas
    add_foreign_key :encuesta_preguntas, :preguntas
  end
end