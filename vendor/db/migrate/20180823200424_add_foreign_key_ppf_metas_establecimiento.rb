class AddForeignKeyPpfMetasEstablecimiento < ActiveRecord::Migration[5.1]
  def change
  	add_reference :set_metas_acciones, :ppf_metas_establecimiento, index: true, foreign_key: true, null: true
  	add_column :set_metas_acciones, :estado, :integer, limit: 1, default: 1 # 1 = pendiente, 2 = aprobada, 3 = rechazada
  end
end
