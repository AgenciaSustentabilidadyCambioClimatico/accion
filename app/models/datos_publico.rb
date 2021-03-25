class DatosPublico < ApplicationRecord

  serialize :visibilidad_documentos
  serialize :visibilidad_empresas_adheridas
  serialize :visibilidad_empresas_certificadas

  enum extension_reporte: [:pdf, :docx]

  def self.load
    #id 1 porque solo sera un registro que contenga la data
    datos_publicos = DatosPublico.find_or_initialize_by(id: 1)
    if datos_publicos.new_record?
      datos_publicos.visibilidad_documentos = ["1","2","3","4"]
      datos_publicos.visibilidad_empresas_adheridas = ["1","2","3","4","5","6","7","8","9"]
      datos_publicos.visibilidad_empresas_certificadas = ["1","2","3","4","5","6","7","8","9","10","11"]
      datos_publicos.extension_reporte = :pdf
      datos_publicos.save
    end
    datos_publicos
  end

end
