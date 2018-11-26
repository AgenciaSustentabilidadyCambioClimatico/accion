class AddComentarioModificacionToProyectos < ActiveRecord::Migration[5.1]
  def change
  	add_column :proyectos, :comentario_modificacion, :text, null: true
  end
end
