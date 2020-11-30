class CreateComentariosInformeAcuerdos < ActiveRecord::Migration[5.1]
  def change
    create_table :comentarios_informe_acuerdos do |t|
      t.references :user, foreign_key: true, null: false
      t.references :informe_acuerdo, foreign_key: true, null: false
      t.string :nombre, null: false
      t.string :rut, null: false
      t.string :email
      t.text :comentario, null: false
      t.timestamps
    end
  end
end
