class AddEstablecimientoToPersonaCargos < ActiveRecord::Migration[5.1]
  def change
    add_reference :persona_cargos, :establecimiento_contribuyente, index: true
  end
end
