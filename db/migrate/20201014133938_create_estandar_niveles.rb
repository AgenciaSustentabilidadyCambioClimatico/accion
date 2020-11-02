class CreateEstandarNiveles < ActiveRecord::Migration[5.1]
  def change
    create_table :estandar_niveles do |t|
      t.integer :numero
      t.string :nombre
      t.decimal :porcentaje, precision: 5, scale: 2
      t.string :archivo
      t.belongs_to :estandar_homologacion, foreign_key: true, index: true
    end
  end
end
