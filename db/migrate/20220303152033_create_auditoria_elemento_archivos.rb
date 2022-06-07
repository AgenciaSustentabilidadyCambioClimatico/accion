class CreateAuditoriaElementoArchivos < ActiveRecord::Migration[5.1]
  def change
    create_table :auditoria_elemento_archivos do |t|
      t.string :archivo
      t.references :auditoria, foreign_key: true
      t.timestamps
    end
  end
end
