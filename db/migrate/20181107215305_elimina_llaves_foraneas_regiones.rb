class EliminaLlavesForaneasRegiones < ActiveRecord::Migration[5.1]
	def up
  	  remove_foreign_key "establecimiento_contribuyentes", "regiones"
  	  remove_foreign_key "regiones", "paises"
	end
  def down
  	  add_foreign_key "establecimiento_contribuyentes", "regiones"
  	  add_foreign_key "regiones", "paises"
  end
end
