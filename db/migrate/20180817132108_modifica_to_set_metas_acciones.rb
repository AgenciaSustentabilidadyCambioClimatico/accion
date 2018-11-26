class ModificaToSetMetasAcciones < ActiveRecord::Migration[5.1]
  def change
  	add_reference :set_metas_acciones, :flujo, foreign_key: true
  	change_column_null :set_metas_acciones, :manifestacion_de_interes_id, true
  	# add_reference :set_metas_acciones, :establecimiento_contribuyente, foreign_key: true, null: true #DZC revisar si afecta a APL
  end
end
