class CreateGastos < ActiveRecord::Migration[5.1]
  def change
    create_table :gastos do |t|
      t.string :nombre
      t.integer :valor_unitario
      t.integer :cantidad
      t.references :tipo_aporte, foreign_key: true
      t.references :flujo, foreign_key: true
      t.references :plan_actividad, foreign_key: true

      t.timestamps
    end
  end
end
