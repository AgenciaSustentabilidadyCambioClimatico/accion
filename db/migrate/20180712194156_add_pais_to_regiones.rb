class AddPaisToRegiones < ActiveRecord::Migration[5.1]
  def change
    add_reference :regiones, :pais, foreign_key: true
  end
end
