class CreateCertificadoProveedorExtras < ActiveRecord::Migration[5.1]
  def change
    create_table :certificado_proveedor_extras do |t|
      t.references :registro_proveedor, foreign_key: true
      t.references :materia_sustancia, foreign_key: true
      t.references :actividad_economica, foreign_key: true
      t.string :archivo

      t.timestamps
    end
  end
end
