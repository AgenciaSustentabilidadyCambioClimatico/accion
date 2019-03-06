class CreateProveedorTipoProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :proveedor_tipo_proveedores do |t|
      t.integer :proveedor_id, null: false
      t.integer :tipo_proveedor_id, null: false
    end
    add_foreign_key :proveedor_tipo_proveedores, :proveedores
    add_foreign_key :proveedor_tipo_proveedores, :tipo_proveedores
  end
end
