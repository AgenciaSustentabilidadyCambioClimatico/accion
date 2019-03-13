class AgregaTareaToConvocatoriaTipos < ActiveRecord::Migration[5.1]
  def change
  	add_column :convocatoria_tipos, :tarea_codigo, :string 
  end
end
