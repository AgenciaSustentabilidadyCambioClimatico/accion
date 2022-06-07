class EditUniqueRutFromContribuyentes < ActiveRecord::Migration[5.1]
  def change
    remove_index :contribuyentes, :rut
    add_index :contribuyentes, :rut
  end
end
