class ArchivoCartasManifestacionDeInteresUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg png pdf zip rar xls xlsx doc docx)
  end

  def size_range
    1.byte..200.megabytes
  end

end
