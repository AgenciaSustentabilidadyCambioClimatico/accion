class CreateEjecucionPresupuestarias < ActiveRecord::Migration[5.1]
  def change
    create_table :ejecucion_presupuestarias do |t|
      t.integer :programa_proyecto_propuesta_id, null: false
      t.integer :centro_de_costo_id, null: false
      t.integer :año, limit: 4, null: false
      t.date :fecha_transferencia, null: false
      t.integer :montos_transferidos, null: false
      t.integer :montos_ejecutados
    end
    add_foreign_key :ejecucion_presupuestarias, :programa_proyecto_propuestas
    add_foreign_key :ejecucion_presupuestarias, :centro_de_costos
  end
end