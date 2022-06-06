class ChangeTelefonoNullUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_null :users, :telefono, true
  end
end
