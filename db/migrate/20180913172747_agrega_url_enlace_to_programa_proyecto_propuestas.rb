class AgregaUrlEnlaceToProgramaProyectoPropuestas < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :url_enlace, :text, null: true
  end
end
