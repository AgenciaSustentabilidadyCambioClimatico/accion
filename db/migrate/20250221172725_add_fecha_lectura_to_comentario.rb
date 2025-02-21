class AddFechaLecturaToComentario < ActiveRecord::Migration[6.0]
  def change
    add_column :comentarios, :fecha_lectura, :datetime
  end
end
