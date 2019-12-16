class AddFieldsToContribuyentes < ActiveRecord::Migration[5.1]
  def change
    add_column :contribuyentes, :temporal, :boolean, default: false
    add_reference :contribuyentes, :flujo, foreign_key: true
  end
end
