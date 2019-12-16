class AddFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :temporal, :boolean, default: false
    add_reference :users, :flujo, foreign_key: true
  end
end
