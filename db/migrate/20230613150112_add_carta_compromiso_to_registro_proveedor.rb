class AddCartaCompromisoToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :carta_compromiso, :string
  end
end
