class AddFieldStatusComuna < ActiveRecord::Migration[5.1]
  def change
  	add_column :comunas, :vigente, :boolean, :null => false, :default => true
  end
end
