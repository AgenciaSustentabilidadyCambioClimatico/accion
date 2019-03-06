class AgregarFieldsVisibilityContribuyente < ActiveRecord::Migration[5.1]
  def change
  	add_column :contribuyentes,  :fields_visibility, :text, null: true
  end
end
