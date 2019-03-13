class CreatePreguntas < ActiveRecord::Migration[5.1]
  def change
    create_table :preguntas do |t|
      t.text :texto, null: false
      t.integer :tipo_respuestas, null: false
    end
  end
end