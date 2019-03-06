class AgregaCodigoTareaToConvocatorias < ActiveRecord::Migration[5.1]
  def change
  	add_column :convocatorias, :tarea_codigo, :string
  end
end
