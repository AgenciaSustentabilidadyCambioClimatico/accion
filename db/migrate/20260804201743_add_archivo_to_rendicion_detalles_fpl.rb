class AddArchivoToRendicionDetallesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_detalles_fpl, :archivo, :string
  end
end
