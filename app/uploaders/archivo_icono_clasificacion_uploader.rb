class ArchivoIconoClasificacionUploader < CarrierWave::Uploader::Base
# Almacenamiento global en config/initializers/carrierwave.rb (:file en test/dev, :fog Azure en prod).

  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg png icon)
  end

  def size_range
    1..15.megabytes
  end
end
