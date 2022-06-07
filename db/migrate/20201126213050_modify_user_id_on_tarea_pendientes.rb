class ModifyUserIdOnTareaPendientes < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :tarea_pendientes, :user_id, true
  end
end
