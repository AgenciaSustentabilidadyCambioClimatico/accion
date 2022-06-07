class AgregaCamposToCampos < ActiveRecord::Migration[5.1]
  def change
  	add_column :campos, :tooltip_activo, :boolean, null: true, default: true
  	add_column :campos, :ayuda_activo, :boolean, null: true, default: true
  end
end
