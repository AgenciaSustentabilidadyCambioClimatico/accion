class AddFieldsToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :secciones_observadas_admisibilidad_juridica, :text
    add_column :manifestacion_de_intereses, :resultado_admisibilidad_juridica, :integer
    add_column :manifestacion_de_intereses, :observaciones_admisibilidad_juridica, :text
    add_column :manifestacion_de_intereses, :respuesta_observaciones_admisibilidad_juridica, :text
    add_column :manifestacion_de_intereses, :archivo_admisibilidad_juridica, :string
    add_column :manifestacion_de_intereses, :fecha_observaciones_admisibilidad_juridica, :timestamp
  end
end
