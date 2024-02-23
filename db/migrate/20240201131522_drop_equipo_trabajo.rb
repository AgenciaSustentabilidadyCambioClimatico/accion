class DropEquipoTrabajo < ActiveRecord::Migration[5.1]
  def change
    drop_table :equipo_trabajos
  end
end
