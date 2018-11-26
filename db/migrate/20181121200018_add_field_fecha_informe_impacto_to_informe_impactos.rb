class AddFieldFechaInformeImpactoToInformeImpactos < ActiveRecord::Migration[5.1]
  def change
  	add_column :informe_impactos, :fecha_informe_impacto, :date, null: true
  end
end