class ArchivoIconoClasificacionUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg png icon)
  end
  
  def size_range
    1..15.megabytes
  end
end