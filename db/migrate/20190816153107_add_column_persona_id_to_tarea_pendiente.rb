class AddColumnPersonaIdToTareaPendiente < ActiveRecord::Migration[5.1]
  def change
    add_reference :tarea_pendientes, :persona, foreign_key: true;
  end
end
