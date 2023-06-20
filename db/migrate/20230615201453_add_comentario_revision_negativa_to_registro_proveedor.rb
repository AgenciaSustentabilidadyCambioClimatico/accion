class AddComentarioRevisionNegativaToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :comentario_negativo, :string
    add_column :registro_proveedores, :calificado, :boolean, default: false
  end
end
