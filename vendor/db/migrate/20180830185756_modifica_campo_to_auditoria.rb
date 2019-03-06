class ModificaCampoToAuditoria < ActiveRecord::Migration[5.1]
  def change
  	remove_column :auditorias, :extension
  	add_column :auditorias, :auditoria_id, :bigint , null: true
  end
end
