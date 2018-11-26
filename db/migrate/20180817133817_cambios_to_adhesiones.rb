class CambiosToAdhesiones < ActiveRecord::Migration[5.1]
  def change
  	add_reference :adhesiones, :flujo, index: true, foreign_key: true
  	change_column_null :adhesiones, :manifestacion_de_interes_id, true
  	remove_index :adhesiones, :manifestacion_de_interes_id
  end
end
