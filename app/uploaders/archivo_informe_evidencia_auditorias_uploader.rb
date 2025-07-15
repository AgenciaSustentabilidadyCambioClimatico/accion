class ArchivoInformeEvidenciaAuditoriasUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(zip rar pdf jpg jpeg png docx)
  end

  def size_range
    1.byte...50.megabytes
  end

end
