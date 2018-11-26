class CreateComentarios < ActiveRecord::Migration[5.1]
  def change
    create_table :comentarios do |t|
    	t.integer :user_id
      t.integer :tipo_comentario_id, null: false
      t.text :comentario, null: false
      t.string :email_contacto, null: false
      t.string :url_referencia
      t.boolean :leido
      t.boolean :resuelto

      t.timestamps
    end
    add_foreign_key :comentarios, :tipo_comentarios
  end
end