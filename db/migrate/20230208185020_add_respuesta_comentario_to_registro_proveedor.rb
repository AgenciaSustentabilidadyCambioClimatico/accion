class AddRespuestaComentarioToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :respuesta_comentario, :string
    add_column :registro_proveedores, :archivo_respuesta_rechazo, :string
  end
end
