class AddCartaDeApoyoCoordinadorToProgramaProyectoPropuestas < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :carta_de_apoyo_coordinador, :text
  end
end