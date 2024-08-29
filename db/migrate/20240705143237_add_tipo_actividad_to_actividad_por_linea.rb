class AddTipoActividadToActividadPorLinea < ActiveRecord::Migration[5.1]
  def change
    add_column :actividad_por_lineas, :tipo_actividad, :integer
  end
end
