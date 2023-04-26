class AddNewFieldsToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :rechazo, :integer, default: 0
    add_column :registro_proveedores, :comentario, :string
  end
end
