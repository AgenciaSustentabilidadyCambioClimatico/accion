class CreateMinutas < ActiveRecord::Migration[5.1]
  def change
    create_table :minutas do |t|
      t.integer :convocatoria_id
      t.date :fecha
      t.string :direccion
      t.decimal :lat
      t.decimal :lng
      t.json :acta
      t.json :lista_asistencia
      t.timestamps
    end
    #add_foreign_key :minutas, :convocatorias
  end
end
