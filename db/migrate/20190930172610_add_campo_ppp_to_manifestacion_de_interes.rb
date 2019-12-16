class AddCampoPppToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :programas_o_proyectos_relacionados_ids, :text
  end
end
