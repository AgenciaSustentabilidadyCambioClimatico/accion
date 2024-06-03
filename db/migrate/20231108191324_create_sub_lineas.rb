class CreateSubLineas < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_lineas do |t|
      t.string :codigo
      t.string :descripcion
      t.references :linea, foreign_key: true

      t.timestamps
    end
  end
end
