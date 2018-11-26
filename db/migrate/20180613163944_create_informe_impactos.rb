class CreateInformeImpactos < ActiveRecord::Migration[5.1]
  def change
    create_table :informe_impactos do |t|
      t.references :manifestacion_de_interes, foreign_key: true
      t.text :observacion
      t.text :documento
      t.boolean :publico, null: false, default: false
      t.string :nombre_documento
      t.timestamps
    end
  end
end
