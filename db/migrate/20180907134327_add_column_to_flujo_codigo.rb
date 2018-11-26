class AddColumnToFlujoCodigo < ActiveRecord::Migration[5.1]
  def change
  	add_column :flujos, :codigo, :string, null: true
  end
end
