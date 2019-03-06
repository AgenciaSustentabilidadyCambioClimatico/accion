class CambiosEjecucionPresupuestariaNullValid < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :ejecucion_presupuestarias, :año, true
  	change_column_null :ejecucion_presupuestarias, :centro_de_costo_id, true
  	change_column_null :ejecucion_presupuestarias, :fecha_transferencia, true
  	change_column_null :ejecucion_presupuestarias, :montos_transferidos, true
  end
end
