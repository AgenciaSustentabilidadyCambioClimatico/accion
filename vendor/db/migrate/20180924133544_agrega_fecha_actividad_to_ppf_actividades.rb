class AgregaFechaActividadToPpfActividades < ActiveRecord::Migration[5.1]
  def change
  	add_column :ppf_actividades, :fecha, :date, null: true
  end
end
