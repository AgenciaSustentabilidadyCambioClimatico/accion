class ModificaToPropuestaDeAcuerdos < ActiveRecord::Migration[5.1]
  def change
  	rename_table :propuesta_de_acuerdos, :set_metas_acciones
  end
end
