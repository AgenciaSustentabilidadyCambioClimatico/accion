class CreatePlanActividades < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_actividades do |t|
      t.string :duracion
      t.references :actividad, foreign_key: true
      t.references :flujo, foreign_key: true
      t.references :objetivos_especifico, foreign_key: true

      t.timestamps
    end
  end
end
