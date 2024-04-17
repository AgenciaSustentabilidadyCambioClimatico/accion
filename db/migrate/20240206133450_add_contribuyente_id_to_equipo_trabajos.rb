class AddContribuyenteIdToEquipoTrabajos < ActiveRecord::Migration[5.1]
  def change
    add_column :equipo_trabajos, :contribuyente_id, :integer
  end
end
