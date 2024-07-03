class AddTipoAporteToRecursoHumano < ActiveRecord::Migration[5.1]
  def change
    add_reference :recurso_humanos, :tipo_aporte, foreign_key: true
  end
end
