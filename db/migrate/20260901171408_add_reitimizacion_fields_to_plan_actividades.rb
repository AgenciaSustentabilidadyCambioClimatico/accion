class AddReitimizacionFieldsToPlanActividades < ActiveRecord::Migration[6.0]
  def change
    add_column :plan_actividades, :autorizado, :boolean
    add_column :plan_actividades, :archivo_reitimizacion, :string
  end
end
