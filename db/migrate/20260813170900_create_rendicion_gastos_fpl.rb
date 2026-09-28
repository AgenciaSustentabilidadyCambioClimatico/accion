class CreateRendicionGastosFpl < ActiveRecord::Migration[6.0]
  def change
    create_table :rendicion_gastos_fpl do |t|
      t.references :rendicion_fpl, null: false, foreign_key: { to_table: :rendiciones_fpl }
      t.references :plan_actividad, null: false, foreign_key: { to_table: :plan_actividades }
      
      t.string  :categoria, null: false          # 'rrhh_propios', 'rrhh_externos', 'operaciones', 'administracion'
      t.integer :item_origen_id, null: false     # ID del registro presupuestado original
      t.string  :tipo_aporte                     # 'solicitado_al_fondo', 'aporte_propio_valorado', 'aporte_propio_liquido'
      
      # Valores y Totales
      t.decimal :valor_unitario, precision: 12, scale: 2, default: 0.0
      t.decimal :cantidad_postulada, precision: 8, scale: 2, default: 0.0
      t.decimal :costo_postulado, precision: 14, scale: 2, default: 0.0
      t.decimal :cantidad_rendida, precision: 8, scale: 2, default: 0.0
      t.decimal :costo_rendido, precision: 14, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :rendicion_gastos_fpl, [:rendicion_fpl_id, :plan_actividad_id, :categoria, :item_origen_id], 
              name: 'idx_rendicion_gastos_unique_item', unique: true
  end
end