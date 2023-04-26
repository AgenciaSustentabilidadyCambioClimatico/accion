class AddEstadoToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :estado, :integer, default: 0
    add_column :registro_proveedores, :user_encargado, :integer
  end
end
