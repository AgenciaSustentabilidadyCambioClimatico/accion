class AddEstablecimientoContribuyenteIdToEstablecimientoContribuyentes < ActiveRecord::Migration[5.1]
  def change
    add_column :establecimiento_contribuyentes, :establecimiento_contribuyente_id, :integer
  end
end
