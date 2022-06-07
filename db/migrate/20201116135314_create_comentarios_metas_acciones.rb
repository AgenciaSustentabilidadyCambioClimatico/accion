class CreateComentariosMetasAcciones < ActiveRecord::Migration[5.1]
  def change
    create_table :comentarios_metas_acciones do |t|
      t.references :user, foreign_key: true, null: false
      t.references :set_metas_accion, foreign_key: true, null: false
      t.string :nombre, null: false
      t.string :rut, null: false
      t.string :email
      t.text :comentario, null: false
      t.timestamps
    end
  end
end
