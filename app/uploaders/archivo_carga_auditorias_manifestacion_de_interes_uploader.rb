class ArchivoCargaAuditoriasManifestacionDeInteresUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf docx doc)
  end

  def size_range
    1.byte...50.megabytes
  end

end
