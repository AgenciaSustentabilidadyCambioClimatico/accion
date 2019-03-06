class CreateComentarioArchivos < ActiveRecord::Migration[5.1]
  def change
    create_table :comentario_archivos do |t|
      t.integer :comentario_id
      t.string :archivo

      t.timestamps
    end
    add_foreign_key :comentario_archivos, :comentarios
  end
end