class AddPostulanteIdToRendicionFpls < ActiveRecord::Migration[7.2]
  def change
    add_column :rendiciones_fpl, :postulante_id, :integer
  end
end
