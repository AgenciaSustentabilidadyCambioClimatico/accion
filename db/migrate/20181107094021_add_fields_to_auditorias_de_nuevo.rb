class AddFieldsToAuditoriasDeNuevo < ActiveRecord::Migration[5.1]
  def change
  	add_column :auditorias, :convocatoria_id, :bigint, null: true
  	add_foreign_key :auditorias, :convocatorias, column: :convocatoria_id
  end
end
