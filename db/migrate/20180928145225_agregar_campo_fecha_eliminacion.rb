class AgregarCampoFechaEliminacion < ActiveRecord::Migration[5.1]
  def change
  	add_column :maquinarias, :fecha_eliminacion, :datetime, null: true
  	add_column :otros, :fecha_eliminacion, :datetime, null: true
  end
end
