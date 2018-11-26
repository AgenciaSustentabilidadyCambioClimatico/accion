class ChangeImagenToJsonOtros < ActiveRecord::Migration[5.1]
  def change
  	change_column :otros, :imagen, 'json USING CAST(imagen AS json)'
  end
end
