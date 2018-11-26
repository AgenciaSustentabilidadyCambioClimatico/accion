class CreateContribuyentes < ActiveRecord::Migration[5.1]
  def change
    create_table :contribuyentes do |t|
      t.integer :rut
      t.string :dv, limit: 1
      t.string :razon_social
    end
    add_index :contribuyentes, :rut, unique: true
  end
end