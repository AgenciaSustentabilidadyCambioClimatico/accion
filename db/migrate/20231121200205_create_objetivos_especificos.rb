class CreateObjetivosEspecificos < ActiveRecord::Migration[5.1]
  def change
    create_table :objetivos_especificos do |t|
      t.references :flujo, foreign_key: true
      t.string :descripcion
      t.string :metodologia
      t.string :resultado
      t.string :indicadores

      t.timestamps
    end
  end
end
