class AddComentarioPostulanteToRendicionDetallesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendicion_detalles_fpl, :comentario_postulante, :text
  end
end
