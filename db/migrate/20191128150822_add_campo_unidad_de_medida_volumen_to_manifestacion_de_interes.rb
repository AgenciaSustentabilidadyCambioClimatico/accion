class AddCampoUnidadDeMedidaVolumenToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :unidad_de_medida_volumen, :text
  end
end
