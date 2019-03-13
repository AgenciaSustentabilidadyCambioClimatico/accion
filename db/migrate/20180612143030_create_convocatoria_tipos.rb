class CreateConvocatoriaTipos < ActiveRecord::Migration[5.1]
  def self.up
    create_table :convocatoria_tipos do |t|
      t.string :descripcion
      t.timestamps
    end
    # add_foreign_key :convocatoria_tipos, :convocatorias
  end
  def self.down
  	drop_table :convocatoria_tipos
  end
end
