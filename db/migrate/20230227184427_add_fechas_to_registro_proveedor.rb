class AddFechasToRegistroProveedor < ActiveRecord::Migration[5.1]
  def change
    add_column :registro_proveedores, :fecha_aprobado, :date
    add_column :registro_proveedores, :fecha_revalidacion, :date
    add_column :registro_proveedores, :archivo_aprobado_directiva, :string
  end
end
