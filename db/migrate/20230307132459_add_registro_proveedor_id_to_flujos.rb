class AddRegistroProveedorIdToFlujos < ActiveRecord::Migration[5.1]
  def change
    add_column :flujos, :registro_proveedor_id, :integer
    add_foreign_key :flujos, :registro_proveedores
  end
end
