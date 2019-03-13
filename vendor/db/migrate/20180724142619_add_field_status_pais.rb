class AddFieldStatusPais < ActiveRecord::Migration[5.1]
  def change
  	add_column :paises, :vigente, :boolean, :null => false, :default => true
  end
end
