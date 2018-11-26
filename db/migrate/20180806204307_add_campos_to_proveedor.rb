class AddCamposToProveedor < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :proveedores, null: true
  	# rellena los registros preexistentes
	  ahora = DateTime.now
	  Proveedor.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :proveedores, :created_at, false
	  change_column_null :proveedores, :updated_at, false
	  add_column :proveedores, :evaluacion, :integer, null: true
  end
end
