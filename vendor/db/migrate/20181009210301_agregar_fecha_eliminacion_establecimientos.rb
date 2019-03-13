class AgregarFechaEliminacionEstablecimientos < ActiveRecord::Migration[5.1]
  def change
  	add_column :establecimiento_contribuyentes, :fecha_eliminacion, :datetime, null: true
  end
end
