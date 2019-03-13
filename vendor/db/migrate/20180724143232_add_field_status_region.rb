class AddFieldStatusRegion < ActiveRecord::Migration[5.1]
  def change
  	add_column :regiones, :vigente, :boolean, :null => false, :default => true
  end
end
