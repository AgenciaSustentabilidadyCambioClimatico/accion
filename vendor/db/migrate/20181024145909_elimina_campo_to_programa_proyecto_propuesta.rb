class EliminaCampoToProgramaProyectoPropuesta < ActiveRecord::Migration[5.1]
  def up
  	remove_foreign_key :programa_proyecto_propuestas, column: :revisor_id
  	remove_column :programa_proyecto_propuestas, :revisor_id
  end
  def down
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :revisor_id
  end
end