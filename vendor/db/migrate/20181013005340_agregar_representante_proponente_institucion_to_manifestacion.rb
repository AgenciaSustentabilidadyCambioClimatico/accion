class AgregarRepresentanteProponenteInstitucionToManifestacion < ActiveRecord::Migration[5.1]
  def change
  	add_column :manifestacion_de_intereses, :proponente_institucion_id, :integer, null: true
  	add_column :manifestacion_de_intereses, :representante_institucion_para_solicitud_id, :integer, null: true
  end
end
