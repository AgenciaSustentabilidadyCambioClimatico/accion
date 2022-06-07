class AddTipoReunionToMinutas < ActiveRecord::Migration[5.1]
  def change
    add_column :minutas, :tipo_reunion, :integer, default: 0
  end
end
