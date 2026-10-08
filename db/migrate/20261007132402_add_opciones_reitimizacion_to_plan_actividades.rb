class AddOpcionesReitimizacionToPlanActividades < ActiveRecord::Migration[6.0]
  def change
    add_column :plan_actividades, :actualizar_equipo, :boolean, default: false
    add_column :plan_actividades, :actualizar_plan, :boolean, default: false
    add_column :plan_actividades, :actualizar_actividad, :boolean, default: false
  end
end
