class AddFieldToFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_reference :fondo_produccion_limpia, :flujo, foreign_key: true
  end
end
