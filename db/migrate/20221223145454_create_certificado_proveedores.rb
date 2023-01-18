class CreateCertificadoProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :certificado_proveedores do |t|
      t.references :registro_proveedor, foreign_key: true
      t.references :materia_sustancia, foreign_key: true
      t.references :actividad_economica, foreign_key: true
      t.string :archivo_certificado

      t.timestamps
    end
  end
end
