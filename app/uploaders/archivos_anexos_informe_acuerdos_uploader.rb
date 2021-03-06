class ArchivosAnexosInformeAcuerdosUploader < CarrierWave::Uploader::Base
  storage :file

  attr_accessor :indice

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg png pdf zip rar xls xlsx doc docx)
  end
end
