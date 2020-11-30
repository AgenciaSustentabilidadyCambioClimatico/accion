class CreateAuditoriaNiveles < ActiveRecord::Migration[5.1]
  def change
    create_table :auditoria_niveles do |t|
      t.belongs_to :auditoria, foreign_key: true, index: true
      t.belongs_to :estandar_nivel, foreign_key: true, index: true
      t.integer :plazo
    end
  end
end
