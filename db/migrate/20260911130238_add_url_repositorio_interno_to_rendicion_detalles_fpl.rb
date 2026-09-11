class AddUrlRepositorioInternoToRendicionDetallesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_detalles_fpl, :url_repositorio_interno, :text
  end
end
