class AddMoreFieldsToEstablecimientoContribuyentes < ActiveRecord::Migration[5.1]
  def change
    add_column :establecimiento_contribuyentes, :telefono, :string
    add_column :establecimiento_contribuyentes, :email, :string
    add_column :establecimiento_contribuyentes, :fields_visibility, :text
  end
end
