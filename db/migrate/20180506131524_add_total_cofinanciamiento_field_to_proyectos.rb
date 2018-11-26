class AddTotalCofinanciamientoFieldToProyectos < ActiveRecord::Migration[5.1]
  def change
  	add_column :proyectos, :total_cofinanciamiento, :integer, null: false, default: 0
  end
end
