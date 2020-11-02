class AddColumnsToSetMetasAcciones < ActiveRecord::Migration[5.1]
  def change
    add_column :set_metas_acciones, :puntaje, :integer
    add_reference :set_metas_acciones, :estandar_nivel, foreign_key: true
    add_column :set_metas_acciones, :id_referencia, :bigint
    add_column :set_metas_acciones, :modelo_referencia, :string

  end
end
