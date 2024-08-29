class CreateFondoProduccionLimpiaMensajes < ActiveRecord::Migration[5.1]
  def change
    create_table :fondo_produccion_limpia_mensajes do |t|
      t.text :body
      t.string :asunto
      t.references :tarea, foreign_key: true

      t.timestamps
    end
  end
end
