class AddCumpleToRendicionDetallesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_detalles_fpl, :cumple, :integer
    add_column :rendicion_detalles_fpl, :comentario_revisor, :text
  end
end
