class CreateRendicionesYDetalles < ActiveRecord::Migration[6.0]
  def change
    # 1. Tabla Principal (Cabecera)
    create_table :rendiciones_fpl do |t|
      t.references :flujo, null: false, foreign_key: true, index: true
      t.integer :mes_a_rendir, null: false
      t.integer :estado, null: false, default: 0 # Enum: 0 = borrador_tecnico, 1 = tecnica_completada, 2 = finalizada

      t.timestamps
    end

    # 2. Tabla de Detalle Única (Técnica, Financiera FPL y Financiera Aporte)
    create_table :rendicion_detalles_fpl do |t|
      t.references :rendicion_fpl, null: false, foreign_key: { to_table: :rendiciones_fpl }, index: true
      t.integer :tipo_tab, null: false, default: 0 # 0: técnica, 1: financiera_fpl, 2: financiera_aporte
      
      # Campos de la pestaña Técnica
      t.boolean :realizada
      t.text :observacion

      t.timestamps
    end

    # 3. Tabla Intermedia apunando a :plan_actividades
    create_table :rendicion_detalle_actividades_fpl do |t|
      t.references :rendicion_detalle_fpl, null: false, foreign_key: { to_table: :rendicion_detalles_fpl }, index: { name: 'idx_rend_det_act_on_det_id' }
      t.references :plan_actividad, null: false, foreign_key: { to_table: :plan_actividades }, index: { name: 'idx_rend_det_act_on_act_id' }

      t.timestamps
    end
  end
end