class AddArchivoToConvocatorias < ActiveRecord::Migration[5.1]
  def change
    add_column :convocatorias, :archivo_adjunto, :json
  end
end
