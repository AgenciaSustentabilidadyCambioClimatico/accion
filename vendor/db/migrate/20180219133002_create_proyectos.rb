class CreateProyectos < ActiveRecord::Migration[5.1]
  def change
    create_table :proyectos do |t|
    	t.string :codigo, null: false
    	t.string :nombre
    	t.integer :contribuyente_id
    	t.string :estado
    	t.date :fecha_informe
        t.boolean :iniciado, default: false
        t.date :fecha_iniciacion
    	t.boolean :oculto, default: false
        t.string :archivo_minuta_reunion
        t.integer :coordinador_id
        t.integer :cogestor_id
        t.integer :revisor_tecnico_id
        t.integer :centro_costos_id
        t.date :fecha_inicio_contrato
        t.date :fecha_fin_contrato
        t.string :archivo_resolucion
        t.string :archivo_contrato
        t.integer :monto_pagar
        t.integer :numero_orden_pago
        t.date :fecha_pago_efectiva
        t.date :fecha_restitucion
        t.integer :monto_restitucion
        t.references :tipo_instrumento
    	t.timestamps
    end
  end
end
