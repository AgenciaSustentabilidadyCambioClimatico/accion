class AddIndexesToActividadEconomicaContribuyentes < ActiveRecord::Migration[6.0]
  def change
    add_index :actividad_economica_contribuyentes, :contribuyente_id, name: 'idx_aec_contribuyente'
    add_index :actividad_economica_contribuyentes, :actividad_economica_id, name: 'idx_aec_actividad'
  end
end