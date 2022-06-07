class AddMostrarEnExcelToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :mostrar_en_excel, :boolean, default: true
  end
end
