class CreateEstablecimientoContribuyentes < ActiveRecord::Migration[5.1]
  def change
    create_table :establecimiento_contribuyentes do |t|
      t.integer :contribuyente_id, null: false
      t.boolean :casa_matriz, default: false
      t.string :direccion
      t.string :ciudad
      t.integer :pais_id
      t.integer :region_id
      t.integer :comuna_id
      t.float :latitud
      t.float :longitud
    end
    add_foreign_key :establecimiento_contribuyentes, :contribuyentes
    add_foreign_key :establecimiento_contribuyentes, :paises
    add_foreign_key :establecimiento_contribuyentes, :regiones
    add_foreign_key :establecimiento_contribuyentes, :comunas
  end
end