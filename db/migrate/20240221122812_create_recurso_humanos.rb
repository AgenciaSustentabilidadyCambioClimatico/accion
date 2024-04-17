class CreateRecursoHumanos < ActiveRecord::Migration[5.1]
  def change
    create_table :recurso_humanos do |t|
      t.integer :hh
      t.references :equipo_trabajo, foreign_key: true
      t.references :flujo, foreign_key: true
      t.references :plan_actividad, foreign_key: true

      t.timestamps
    end
  end
end
