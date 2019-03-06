class EliminaCamposToProgramaProyectoPropuesta < ActiveRecord::Migration[5.1]
  def up
  	remove_foreign_key :programa_proyecto_propuestas, column: :usuario_visitas_id
  	remove_column :programa_proyecto_propuestas, :usuario_visitas_id
 		remove_foreign_key :programa_proyecto_propuestas, column: :usuario_carga_datos_id
  	remove_column :programa_proyecto_propuestas, :usuario_carga_datos_id

  end
  def down
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :usuario_visitas_id
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :usuario_carga_datos_id  	
  end
end