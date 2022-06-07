class AddColumnIdReferenceToCampos < ActiveRecord::Migration[5.1]
  def change
    add_column :campos, :id_referencial, :text, null: true
  end
end
