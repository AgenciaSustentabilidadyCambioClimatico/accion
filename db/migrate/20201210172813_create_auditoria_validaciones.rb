class CreateAuditoriaValidaciones < ActiveRecord::Migration[5.1]
  def change
    create_table :auditoria_validaciones do |t|
      t.references :auditoria, foreign_key: true
      t.references :user, foreign_key: true
      t.text :validaciones, null: true
      t.string :archivo, null: true
      t.timestamps
    end
  end
end
