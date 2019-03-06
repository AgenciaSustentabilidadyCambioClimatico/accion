class CreateAuditorias < ActiveRecord::Migration[5.1]
  def change
    create_table :auditorias do |t|
      t.references :manifestacion_de_interes, index: true, foreign_key: true
      t.string :nombre
      t.integer :plazo
      t.boolean :con_certificacion, default: false
      t.boolean :con_validacion, default: false
      t.boolean :final, default: false
    end
  end
end
