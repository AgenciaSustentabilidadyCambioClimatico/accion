class BorraProyectosFinanciamientosToProyectosFinanciamientos < ActiveRecord::Migration[5.1]
  def change
  	drop_table 'proyectos_financiamientos'
  end
end
