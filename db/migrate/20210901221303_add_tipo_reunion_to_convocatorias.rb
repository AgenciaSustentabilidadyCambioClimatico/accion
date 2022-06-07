class AddTipoReunionToConvocatorias < ActiveRecord::Migration[5.1]
  def change
    add_column :convocatorias, :tipo_reunion, :integer, default: 0
  end
end
