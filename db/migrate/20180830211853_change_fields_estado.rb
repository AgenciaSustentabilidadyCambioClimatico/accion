class ChangeFieldsEstado < ActiveRecord::Migration[5.1]
  def change
  	remove_column :auditoria_elementos, :en_revision
  	remove_column :auditoria_elementos, :auditoria_aprobada
  	add_column :auditoria_elementos, :estado, :integer, limit: 1, default: 1 
  end
end
