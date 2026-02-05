class AddCorrelativoToPlanActividades < ActiveRecord::Migration[6.0]
  def change
    add_column :plan_actividades, :correlativo, :string
  end
end
