class AddComentarioToPropuestaDeAcuerdos < ActiveRecord::Migration[5.1]
  def change
    add_column :propuesta_de_acuerdos, :comentario, :text
    add_column :propuesta_de_acuerdos, :comentario_respuesta, :text
  end
end
