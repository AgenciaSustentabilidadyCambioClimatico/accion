class AddRevisorIdToProgramaProyectoPropuestas < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :revisor_id, :integer
  	add_column :programa_proyecto_propuestas, :comentario_al_asignar_revisor, :text
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :revisor_id
  end
end