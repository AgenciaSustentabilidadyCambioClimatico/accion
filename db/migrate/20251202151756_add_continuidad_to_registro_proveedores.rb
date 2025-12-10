class AddContinuidadToRegistroProveedores < ActiveRecord::Migration[6.0]
  def change
    add_column :registro_proveedores, :continuidad, :boolean
  end
end
