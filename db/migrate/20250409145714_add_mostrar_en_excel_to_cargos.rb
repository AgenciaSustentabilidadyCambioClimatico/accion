class AddMostrarEnExcelToCargos < ActiveRecord::Migration[6.0]
  def change
    add_column :cargos, :mostrar_en_excel, :boolean, default: true
  end
end
