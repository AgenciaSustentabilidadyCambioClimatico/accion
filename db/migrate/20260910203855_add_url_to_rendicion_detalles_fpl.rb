class AddUrlToRendicionDetallesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_detalles_fpl, :url_respaldo, :text
    add_column :rendicion_detalles_fpl, :descripcion_url, :string
  end
end
