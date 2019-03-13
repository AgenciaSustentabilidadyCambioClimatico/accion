class AgregaFlujoIdToConvocatorias < ActiveRecord::Migration[5.1]
  def change
  	add_reference :convocatorias, :flujo, foreign_key: true #crea el campo flujo_id y lo referencia como llave foránea a la llave primaria de la tabla flujos. Se usa la tabla en singular para que el campo creado tambien tenga nombre en singular
  end
end
