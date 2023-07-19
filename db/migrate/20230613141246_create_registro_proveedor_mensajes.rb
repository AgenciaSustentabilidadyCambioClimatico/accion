class CreateRegistroProveedorMensajes < ActiveRecord::Migration[5.1]
  def change
    create_table :registro_proveedor_mensajes do |t|
      t.text :body
      t.string :asunto
      t.references :tarea, foreign_key: true

      t.timestamps
    end
  end
end
