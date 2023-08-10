class AddArchivoResolucionToMinutas < ActiveRecord::Migration[5.1]
  def change
    add_column :minutas, :archivo_resolucion, :string
  end
end
