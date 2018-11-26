class CreateConvocatorias < ActiveRecord::Migration[5.1]
  def change
    create_table :convocatorias do |t|
      t.integer :manifestacion_de_interes_id
      t.date :fecha
      t.string :direccion
      t.decimal :lat
      t.decimal :lng
      t.string :encabezado
      t.string :mensaje
      t.timestamps
    end
    add_foreign_key :convocatorias, :manifestacion_de_intereses
  end
end
