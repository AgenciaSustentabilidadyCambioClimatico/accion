class CreateInstrumentos < ActiveRecord::Migration[5.1]
  def change
    create_table :instrumentos do |t|
      t.integer :tipo_instrumento_id
      t.integer :nivel
      t.string :nombre
      t.text :poligono_ubicacion
      t.string :glosario
      t.string :certificaciones_homologables
    end
    add_foreign_key :instrumentos, :tipo_instrumentos
  end
end