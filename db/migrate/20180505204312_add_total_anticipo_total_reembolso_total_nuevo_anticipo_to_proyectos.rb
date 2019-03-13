class AddTotalAnticipoTotalReembolsoTotalNuevoAnticipoToProyectos < ActiveRecord::Migration[5.1]
  def change
  	add_column :proyectos, :total_anticipo, :integer, default: 0
  	add_column :proyectos, :total_reembolso, :integer, default: 0
  	add_column :proyectos, :total_nuevo_anticipo, :integer, default: 0
  end
end
