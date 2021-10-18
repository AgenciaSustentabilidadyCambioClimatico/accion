class ChangeTelefonoOnAdhesiones < ActiveRecord::Migration[5.1]
  def change
    change_column :adhesiones, :fono_representante_legal, :bigint
  end
end
