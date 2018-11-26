class AgregarCamposProyectosHistoricos < ActiveRecord::Migration[5.1]
  def change
  	add_column :proyectos, :territorios_regiones, :text, null: true
  	add_column :proyectos, :territorios_provincias, :text, null: true
  	add_column :proyectos, :territorios_comunas, :text, null: true
  	add_column :proyectos, :instrumentos_relacionados_historico, :text, null: true
  	add_column :proyectos, :sectores_economicos, :text, null: true
  	add_column :proyectos, :motivacion_y_objetivos, :text, null: true
  end
end
