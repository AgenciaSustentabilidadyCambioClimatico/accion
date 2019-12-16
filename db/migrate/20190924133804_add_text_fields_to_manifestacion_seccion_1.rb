class AddTextFieldsToManifestacionSeccion < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :relacion_de_politicas, :text
    add_column :manifestacion_de_intereses, :fuente_de_fondos, :text
    add_column :manifestacion_de_intereses, :justificacion_de_estimacion_de_fondos_requeridos, :text
    add_column :manifestacion_de_intereses, :nombre_de_estandar_certificable, :text
    add_column :manifestacion_de_intereses, :diagnostico_de_acuerdo_propuesto, :text
  end
end
