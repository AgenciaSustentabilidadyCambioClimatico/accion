class AlterTableUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :rut
    remove_index :users, :email
    add_index :users, :rut
    add_index :users, :email
    add_reference :users, :user, foreign_key: true
  end
end
