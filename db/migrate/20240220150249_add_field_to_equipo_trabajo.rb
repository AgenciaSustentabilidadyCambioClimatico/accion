class AddFieldToEquipoTrabajo < ActiveRecord::Migration[5.1]
  def change
    add_column :equipo_trabajos, :hh, :integer
  end
end
