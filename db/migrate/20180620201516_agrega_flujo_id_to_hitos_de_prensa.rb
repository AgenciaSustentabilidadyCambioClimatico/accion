class AgregaFlujoIdToHitosDePrensa < ActiveRecord::Migration[5.1]
  def change
    add_reference :hitos_de_prensa, :flujo, foreign_key: true
  end
end
