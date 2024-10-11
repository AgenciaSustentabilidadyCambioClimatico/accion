class ArchivoAdhesionYDocumentacionAdhesionesUploader < CarrierWave::Uploader::Base
  storage :aws

  CarrierWave.configure do |config|
    config.remove_previously_stored_files_after_update = false
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(xls xlsx zip rar pdf jpg jpeg png docx doc)
  end

end
