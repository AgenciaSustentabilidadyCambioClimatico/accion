class CreateDocumentoProveedorExtras < ActiveRecord::Migration[5.1]
  def change
    create_table :documento_proveedor_extras do |t|
      t.references :registro_proveedor, foreign_key: true
      t.string :archivo
      t.string :description

      t.timestamps
    end
  end
end
