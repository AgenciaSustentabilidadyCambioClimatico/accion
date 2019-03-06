class CreateProyectoPagos < ActiveRecord::Migration[5.1]
  def change
  	create_table :proyecto_pagos do |t|
      t.references :proyecto, foreign_key: true
      t.datetime :fecha_pago, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :monto, null: false
      t.integer :numero_orden_pago
      t.date :fecha_pago_efectiva
    end
  end
end
