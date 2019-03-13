class AddFieldsToEstablecimientoContribuyentes < ActiveRecord::Migration[5.1]
  def change
    add_column :establecimiento_contribuyentes, :nombre_de_establecimiento, :string
    add_column :establecimiento_contribuyentes, :tipo_de_establecimiento, :string
  end
end
