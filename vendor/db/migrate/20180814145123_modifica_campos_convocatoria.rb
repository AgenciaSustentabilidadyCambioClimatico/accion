class ModificaCamposConvocatoria < ActiveRecord::Migration[5.1]
  def change
  	rename_column :convocatorias, :encabezado, :mensaje_encabezado
  	rename_column :convocatorias, :mensaje, :mensaje_cuerpo
  end
end
