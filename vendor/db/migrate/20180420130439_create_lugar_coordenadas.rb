class CreateLugarCoordenadas < ActiveRecord::Migration[5.1]
  def change
    create_table :lugar_coordenadas do |t|
      t.string :lugar
      t.float :latitud
      t.float :longitud
    end
    add_index :lugar_coordenadas, :lugar
  end
end