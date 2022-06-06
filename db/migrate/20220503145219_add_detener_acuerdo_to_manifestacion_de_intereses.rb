class AddDetenerAcuerdoToManifestacionDeIntereses < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :comentarios_y_observaciones_detencion_acuerdo, :text, null: true
    add_column :manifestacion_de_intereses, :fecha_detencion_acuerdo, :timestamp
    add_column :manifestacion_de_intereses, :detenido, :boolean, default: false
  end
end
