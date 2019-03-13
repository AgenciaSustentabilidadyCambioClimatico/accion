class CreateMateriaSustanciaClasificaciones < ActiveRecord::Migration[5.1]
  def change
    create_table :materia_sustancia_clasificaciones do |t|
      t.integer :materia_sustancia_id, null: false
      t.integer :clasificacion_id, null: false
    end
    add_foreign_key :materia_sustancia_clasificaciones, :materia_sustancias
    add_foreign_key :materia_sustancia_clasificaciones, :clasificaciones
  end
end