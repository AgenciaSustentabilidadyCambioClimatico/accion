class AddManifestacionDeInteresIdFieldToFlujos < ActiveRecord::Migration[5.1]
  def change
  	add_column :flujos, :manifestacion_de_interes_id, :integer
    add_foreign_key :flujos, :manifestacion_de_intereses
  end
end