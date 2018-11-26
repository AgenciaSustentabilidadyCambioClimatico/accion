class AddArchivoActaComiteAnexoFieldsToPropuestaDeAcuerdos < ActiveRecord::Migration[5.1]
  def change
    add_column :propuesta_de_acuerdos, :archivo_acta_comite, :string
    add_column :propuesta_de_acuerdos, :anexo, :boolean, default: false
  end
end
