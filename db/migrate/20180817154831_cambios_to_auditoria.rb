class CambiosToAuditoria < ActiveRecord::Migration[5.1]
  def change
  	add_reference :auditorias, :flujo, index: true, foreign_key: true
  	change_column_null :auditorias, :manifestacion_de_interes_id, true
  	remove_index :auditorias, :manifestacion_de_interes_id
  	add_column :auditorias, :extension, :boolean, null: true
  end
end
