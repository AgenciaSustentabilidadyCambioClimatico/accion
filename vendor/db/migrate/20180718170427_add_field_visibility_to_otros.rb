class AddFieldVisibilityToOtros < ActiveRecord::Migration[5.1]
  def change
  	add_column :otros, :fields_visibility, :text
  end
end
