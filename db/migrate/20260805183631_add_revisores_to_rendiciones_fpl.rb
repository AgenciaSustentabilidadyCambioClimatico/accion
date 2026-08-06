class AddRevisoresToRendicionesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendiciones_fpl, :revisor_tecnico_id, :integer
    add_column :rendiciones_fpl, :revisor_financiero_id, :integer
    add_column :rendiciones_fpl, :comentario_asignar_revisor, :text
  end
end
