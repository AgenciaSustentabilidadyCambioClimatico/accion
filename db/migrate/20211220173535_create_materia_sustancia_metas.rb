class CreateMateriaSustanciaMetas < ActiveRecord::Migration[5.1]
  def change
    create_table :materia_sustancia_metas do |t|
      t.references :materia_sustancia, foreign_key: true
      t.references :clasificacion, foreign_key: true
    end
  end
end
