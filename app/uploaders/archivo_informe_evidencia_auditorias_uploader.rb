class ArchivoInformeEvidenciaAuditoriasUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(zip rar pdf jpg jpeg png docx)
  end

end