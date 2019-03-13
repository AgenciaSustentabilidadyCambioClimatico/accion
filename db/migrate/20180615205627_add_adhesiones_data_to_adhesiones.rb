class AddAdhesionesDataToAdhesiones < ActiveRecord::Migration[5.1]
  def change
    add_column :adhesiones, :adhesiones_data, :text
    add_column :adhesiones, :aceptado, :boolean
    add_column :adhesiones, :observaciones, :text
  end
end
