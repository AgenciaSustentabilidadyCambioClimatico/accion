class DropFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    drop_table :fondo_produccion_limpia
  end
end
