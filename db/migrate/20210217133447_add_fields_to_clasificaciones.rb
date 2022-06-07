class AddFieldsToClasificaciones < ActiveRecord::Migration[5.1]
  def change
    add_column :clasificaciones, :imagen, :string, null: true
    add_column :clasificaciones, :icono, :string, null: true
    add_column :clasificaciones, :color, :string, null: true
  end
end
