class AddCamposResumenToRendicionesFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendiciones_fpl, :resultado_actividades_realizadas, :text
    add_column :rendiciones_fpl, :informacion_adicional, :text
    add_column :rendiciones_fpl, :conclusion, :text
  end
end
