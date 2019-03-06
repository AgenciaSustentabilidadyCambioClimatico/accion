class CreateActividadEconomicaContribuyentes < ActiveRecord::Migration[5.1]
  def change
    create_table :actividad_economica_contribuyentes do |t|
      t.integer :actividad_economica_id
      t.integer :contribuyente_id
    end
    add_foreign_key :actividad_economica_contribuyentes, :actividad_economicas
    add_foreign_key :actividad_economica_contribuyentes, :contribuyentes
  end
end
