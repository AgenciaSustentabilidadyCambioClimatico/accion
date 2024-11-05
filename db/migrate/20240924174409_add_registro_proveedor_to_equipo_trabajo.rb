class AddRegistroProveedorToEquipoTrabajo < ActiveRecord::Migration[5.1]
  def change
    add_reference :equipo_trabajos, :registro_proveedores, foreign_key: true
  end
end
