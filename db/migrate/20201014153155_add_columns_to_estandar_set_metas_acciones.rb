class AddColumnsToEstandarSetMetasAcciones < ActiveRecord::Migration[5.1]
  def change
    add_column :estandar_set_metas_acciones, :puntaje, :integer
    add_reference :estandar_set_metas_acciones, :estandar_nivel, foreign_key: true
  end
end
