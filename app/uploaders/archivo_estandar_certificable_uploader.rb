class ArchivoEstandarCertificableUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg png pdf zip rar xls xlsx doc docx)
  end
  
  def size_range
    1..400.megabytes
  end
end