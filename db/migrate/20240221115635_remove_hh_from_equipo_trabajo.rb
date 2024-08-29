class RemoveHhFromEquipoTrabajo < ActiveRecord::Migration[5.1]
  def change
    remove_column :equipo_trabajos, :hh, :integer
  end
end
