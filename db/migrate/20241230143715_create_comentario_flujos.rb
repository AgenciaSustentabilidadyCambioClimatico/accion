class CreateComentarioFlujos < ActiveRecord::Migration[5.1]
  def change
    create_table :comentario_flujos do |t|
      t.string :comentario
      t.references :flujo, foreign_key: true
      t.references :user, foreign_key: true
      t.references :tarea, foreign_key: true

      t.timestamps
    end
  end
end
