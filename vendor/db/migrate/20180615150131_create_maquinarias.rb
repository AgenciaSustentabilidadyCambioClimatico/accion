class CreateMaquinarias < ActiveRecord::Migration[5.1]
  def change
    create_table :maquinarias do |t|
      t.references :establecimiento_contribuyente, foreign_key: true
      t.string :nombre_maquinaria
      t.string :numero_serie
      t.string :patente

      t.timestamps
    end
  end
end
