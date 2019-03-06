class RenameCamposOtros < ActiveRecord::Migration[5.1]
  def up
  	rename_column :otros, :contribuyentes_id, :contribuyente_id
  end
  def down
  	rename_column :otros, :contribuyente_id, :contribuyentes_id
  end
end
