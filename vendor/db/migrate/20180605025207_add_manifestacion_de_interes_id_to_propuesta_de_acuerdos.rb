class AddManifestacionDeInteresIdToPropuestaDeAcuerdos < ActiveRecord::Migration[5.1]
  def change
  	add_column :propuesta_de_acuerdos, :manifestacion_de_interes_id, :integer, null: false
  	add_foreign_key :propuesta_de_acuerdos, :manifestacion_de_intereses
  end
end
