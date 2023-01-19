class AddFieldsToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :rut_institucion, :string
    add_column :registro_proveedores, :nombre_institucion, :string
    add_column :registro_proveedores, :tipo_contribuyente, :integer
    add_column :registro_proveedores, :direccion_casa_matriz, :string
    add_column :registro_proveedores, :region_casa_matriz, :string
    add_column :registro_proveedores, :comuna_casa_matriz, :string
    add_column :registro_proveedores, :ciudad_casa_matriz, :string
    add_reference :registro_proveedores, :tipo_proveedor, foreign_key: true
  end
end
