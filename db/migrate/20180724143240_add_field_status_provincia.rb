class AddFieldStatusProvincia < ActiveRecord::Migration[5.1]
  def change
  	add_column :provincias, :vigente, :boolean, :null => false, :default => true
  end
end
