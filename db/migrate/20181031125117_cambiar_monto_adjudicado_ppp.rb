class CambiarMontoAdjudicadoPpp < ActiveRecord::Migration[5.1]
  def change
  	change_column :programa_proyecto_propuestas, :monto_adjudicado, :bigint
  end
end
