class CreateDatosPublicos < ActiveRecord::Migration[5.1]
  def change
    create_table :datos_publicos do |t|
      t.text :visibilidad_documentos
      t.text :visibilidad_empresas_adheridas
      t.text :visibilidad_empresas_certificadas
      t.integer :extension_reporte
      t.timestamps
    end
  end
end
