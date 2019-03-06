class AddTimestampsFieldsToTareaPendientes < ActiveRecord::Migration[5.1]
  def change
  	add_column :tarea_pendientes, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  	add_column :tarea_pendientes, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end