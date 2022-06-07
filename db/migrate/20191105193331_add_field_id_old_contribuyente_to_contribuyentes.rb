class AddFieldIdOldContribuyenteToContribuyentes < ActiveRecord::Migration[5.1]
  def change
    add_reference :contribuyentes, :contribuyente, foreign_key: true
  end
end
