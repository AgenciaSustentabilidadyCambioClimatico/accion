class RemoveCamposFromConvocatorias < ActiveRecord::Migration[5.1]
  def change
    remove_column :convocatorias, :acta, :text
    remove_column :convocatorias, :lista_asistencia, :text
  end
end
