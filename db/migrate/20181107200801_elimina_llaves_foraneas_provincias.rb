class EliminaLlavesForaneasProvincias < ActiveRecord::Migration[5.1]
  def up
  	remove_foreign_key "comunas", "provincias"
  	remove_foreign_key "provincias", "regiones"
  end
  def down
  	add_foreign_key "provincias", "regiones"
  	add_foreign_key "comunas", "provincias"
  end
end