class CreateNotaRegistroProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :nota_registro_proveedores do |t|
      t.references :registro_proveedor, foreign_key: true
      t.references :manifestacion_de_interes, foreign_key: true
      t.integer :nota, default: 0

      t.timestamps
    end
  end
end
