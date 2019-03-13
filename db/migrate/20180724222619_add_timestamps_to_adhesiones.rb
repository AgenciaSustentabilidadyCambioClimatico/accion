class AddTimestampsToAdhesiones < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :adhesiones, null: true
  end
end
