class AddEstadoToListadoAdhesionesTemporals < ActiveRecord::Migration[6.0]
  def change
    add_column :listado_adhesiones_temporals, :estado, :integer, default: 0, null: false
  end
end
