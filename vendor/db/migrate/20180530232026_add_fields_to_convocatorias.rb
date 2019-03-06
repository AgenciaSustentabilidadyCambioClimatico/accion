class AddFieldsToConvocatorias < ActiveRecord::Migration[5.1]
  def up
    add_column :convocatorias, :acta, :text
    add_column :convocatorias, :lista_asistencia, :text
  end

  def down
  	remove_column :convocatorias, :acta, :text
    remove_column :convocatorias, :lista_asistencia, :text
  end
end
