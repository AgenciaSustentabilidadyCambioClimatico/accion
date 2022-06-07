class ModifyFieldsFirmaCeremoniaCeritifcacionManifestacionDeintereses < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :firma_tipo_reunion, :integer, default: 0
    add_column :manifestacion_de_intereses, :firma_fecha_hora, :datetime
    add_column :manifestacion_de_intereses, :ceremonia_certificacion_tipo_reunion, :integer, default: 0
    add_column :manifestacion_de_intereses, :ceremonia_certificacion_fecha_hora, :datetime
  end
end
