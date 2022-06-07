class EditFieldsManifestacionDeIntereses < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :cadena_de_valor, :text
    add_column :manifestacion_de_intereses, :otras_caracteristicas_relevantes, :text
  end
end
