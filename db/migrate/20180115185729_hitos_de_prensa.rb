class HitosDePrensa < ActiveRecord::Migration[5.1]
  def change
    create_table :hitos_de_prensa do |t|
      t.integer :tipo_de_medio_id, null: false
      t.string :nombre, null: false
      t.string :medio, null: false
      t.date :fecha_publicacion, null: false
      t.string :enlace
      t.text :observaciones

      t.timestamps
    end
    add_foreign_key :hitos_de_prensa, :tipo_de_medios
  end
end
