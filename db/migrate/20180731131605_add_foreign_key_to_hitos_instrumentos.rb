class AddForeignKeyToHitosInstrumentos < ActiveRecord::Migration[5.1]
  def change
  	add_foreign_key :hito_de_prensa_instrumentos, :flujos, column: :flujo_id
  end
end
