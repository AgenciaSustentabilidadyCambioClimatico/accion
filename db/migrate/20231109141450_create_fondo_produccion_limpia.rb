class CreateFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    create_table :fondo_produccion_limpia do |t|
      t.string :proponente
      t.string :nombre_acuerdo
      t.references :flujo, foreign_key: true
      t.references :linea, foreign_key: true
      t.references :sub_linea, foreign_key: true

      t.timestamps
    end
  end
end
