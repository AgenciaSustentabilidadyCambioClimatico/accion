class CreateDocumentoRegistroProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :documento_registro_proveedores do |t|
      t.string :archivo
      t.string :description
      t.references :registro_proveedor, foreign_key: true

      t.timestamps
    end
  end
end
