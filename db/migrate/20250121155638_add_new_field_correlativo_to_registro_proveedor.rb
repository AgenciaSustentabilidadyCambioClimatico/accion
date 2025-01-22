class AddNewFieldCorrelativoToRegistroProveedor < ActiveRecord::Migration[6.0]
  def change
    add_column :registro_proveedores, :correlativo, :integer
  end
end
