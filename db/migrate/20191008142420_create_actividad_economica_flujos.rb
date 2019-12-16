class CreateActividadEconomicaFlujos < ActiveRecord::Migration[5.1]
  def change
    create_table :actividad_economica_flujos do |t|
      t.references :actividad_economica, foreign_key: true
      t.references :flujo, foreign_key: true
      t.timestamps
    end
  end
end
