class AddCampoTipoToConvocatorias < ActiveRecord::Migration[5.1]
  def change
    add_column :convocatorias, :tipo, :integer
  end
end
