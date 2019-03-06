class ChangeFieldFkMaquinaria < ActiveRecord::Migration[5.1]
  def up
  	rename_column :maquinarias, :contribuyentes_id, :contribuyente_id
  end
  def down
  	rename_column :maquinarias, :contribuyente_id, :contribuyentes_id
  end
end
