class AddLeidoYResueltoToComentarios < ActiveRecord::Migration[6.0]
  def change
    add_column :comentarios, :comentario_leido, :string
    add_column :comentarios, :comentario_resuelto, :string
  end
end
