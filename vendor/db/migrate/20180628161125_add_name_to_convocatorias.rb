class AddNameToConvocatorias < ActiveRecord::Migration[5.1]
  def change
  	add_column :convocatorias, :nombre, :text
  end
end
