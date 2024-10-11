class ArchivoRespuestasPertinenciasFactibilidadesManifestacionDeInteresUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf docx png jpg zip)
  end

end
