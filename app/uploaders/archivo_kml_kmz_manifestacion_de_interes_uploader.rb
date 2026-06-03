class ArchivoKmlKmzManifestacionDeInteresUploader < CarrierWave::Uploader::Base
# Almacenamiento global en config/initializers/carrierwave.rb (:file en test/dev, :fog Azure en prod).

  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(kml kmz csv tsv xlsx gpx)
  end

end
