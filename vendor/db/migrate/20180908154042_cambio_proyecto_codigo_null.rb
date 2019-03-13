class CambioProyectoCodigoNull < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :proyectos, :codigo, true
  end
end
