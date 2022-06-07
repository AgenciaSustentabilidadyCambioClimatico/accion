class ArchivoRevisionAuditoriasUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf docx doc zip rar)
  end

  def size_range
	  1.byte..200.megabytes
	end

end