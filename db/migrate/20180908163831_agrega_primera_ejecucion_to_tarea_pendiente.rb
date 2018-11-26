class AgregaPrimeraEjecucionToTareaPendiente < ActiveRecord::Migration[5.1]
  def change
  	add_column :tarea_pendientes, :primera_ejecucion, :boolean, default: true
  end
end
