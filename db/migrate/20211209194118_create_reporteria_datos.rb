class CreateReporteriaDatos < ActiveRecord::Migration[5.1]
  def change
    create_table :reporteria_datos do |t|
      t.string :ruta
      t.integer :clasificacion_id
      t.integer :acuerdo_id
      t.string :vista
      t.text :datos
      t.timestamps
    end
  end
end
