class CreateOtros < ActiveRecord::Migration[5.1]
  def change
    create_table :otros do |t|
      t.references :establecimiento_contribuyente, foreign_key: true
      t.references :alcance, foreign_key: true
      t.references :contribuyentes, foreign_key: true
      t.string :nombre
      t.string :tipo
      t.string :identificador_unico
      t.string :imagen

      t.timestamps
    end
  end
end
