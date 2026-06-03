class ArchivoRevisionAuditoriasUploader < CarrierWave::Uploader::Base
# Almacenamiento global en config/initializers/carrierwave.rb (:file en test/dev, :fog Azure en prod).

  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf docx doc zip rar)
  end

  def size_range
	  1.byte..200.megabytes
	end

end
