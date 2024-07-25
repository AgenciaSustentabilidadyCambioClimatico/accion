class AddFondoProduccionLimpiaToFlujo < ActiveRecord::Migration[5.1]
  def change
    add_reference :flujos, :fondo_produccion_limpia, foreign_key: true
  end
end
