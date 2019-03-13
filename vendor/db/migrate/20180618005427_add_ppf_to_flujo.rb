class AddPpfToFlujo < ActiveRecord::Migration[5.1]
  def change
  	add_column :flujos, :programa_proyecto_propuesta_id, :integer
  	add_foreign_key :flujos, :programa_proyecto_propuestas
  end
end
