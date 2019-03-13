class EliminaCamposNombreToUser < ActiveRecord::Migration[5.1]
  def change
  	remove_column :users, :nombres
  	remove_column :users, :apellido_paterno
  	remove_column :users, :apellido_materno
  end
end
