class AddContribuyenteIdToMaquinarias < ActiveRecord::Migration[5.1]
  def change
  	add_reference :maquinarias, :contribuyentes, foreign_key: true
  end
end
