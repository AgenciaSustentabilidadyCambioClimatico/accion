class ArchivoPertinenciasFactibilidadesManifestacionDeInteresUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "accion/public/accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf docx png jpg)
  end

end
