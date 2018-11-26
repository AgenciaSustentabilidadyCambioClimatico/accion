class CreatePersonas < ActiveRecord::Migration[5.1]
  def change
    create_table :personas do |t|
      t.integer :user_id, null: false
      t.integer :contribuyente_id, null: false
      t.integer :establecimiento_contribuyente_id
      t.string  :email_institucional
      t.string  :telefono_institucional
      t.timestamps
    end
    add_foreign_key :personas, :users
    add_foreign_key :personas, :contribuyentes
    add_foreign_key :personas, :establecimiento_contribuyentes
  end
end