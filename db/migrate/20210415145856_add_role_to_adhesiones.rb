class AddRoleToAdhesiones < ActiveRecord::Migration[5.1]
  def change
    add_reference :adhesiones, :rol, foreign_key: true
  end
end
