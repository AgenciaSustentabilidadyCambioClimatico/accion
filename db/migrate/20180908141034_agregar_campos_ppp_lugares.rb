class AgregarCamposPppLugares < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :territorios_regiones, :text, null: true
  	add_column :programa_proyecto_propuestas, :territorios_provincias, :text, null: true
  	add_column :programa_proyecto_propuestas, :territorios_comunas, :text, null: true
  	add_column :programa_proyecto_propuestas, :instrumentos_relacionados_historico, :text, null: true
  end
end
