class AddRespuestaComentarioToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :respuesta_comentario, :string
    add_column :registro_proveedores, :archivo_respuesta_rechazo, :string
    add_column :registro_proveedores, :comentario_directiva, :string
    add_column :registro_proveedores, :respuesta_comentario_directiva, :string
    add_column :registro_proveedores, :archivo_respuesta_rechazo_directiva, :string
    add_column :registro_proveedores, :rechazo_directiva, :integer, default: 0
  end
end
