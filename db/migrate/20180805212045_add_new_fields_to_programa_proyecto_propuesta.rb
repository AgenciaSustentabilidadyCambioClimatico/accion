class AddNewFieldsToProgramaProyectoPropuesta < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :proyecto_con_atencion_directa_a_beneficiarios, :boolean
  	add_column :programa_proyecto_propuestas, :sectores_economicos, :text
  end
end