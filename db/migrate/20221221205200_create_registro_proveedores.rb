class CreateRegistroProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :registro_proveedores do |t|
      t.string :rut
      t.string :nombre
      t.string :apellido
      t.string :email
      t.string :telefono
      t.string :profesion
      t.string :direccion
      t.string :region
      t.string :comuna
      t.string :ciudad
      t.boolean :terminos_y_servicion, default: false
      t.boolean :asociar_institucion, default: false
      t.string :documentos
      t.references :contribuyente, foreign_key: true
      t.references :tipo_contribuyente, foreign_key: true

      t.timestamps
    end
  end
end
