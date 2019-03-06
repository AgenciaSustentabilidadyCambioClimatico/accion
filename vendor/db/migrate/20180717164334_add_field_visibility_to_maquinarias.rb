class AddFieldVisibilityToMaquinarias < ActiveRecord::Migration[5.1]
  def change
  	add_column :maquinarias, :fields_visibility, :text
  end
end
