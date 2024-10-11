class ArchivosAnexosPosterioresFirmasInformeAcuerdosUploader < CarrierWave::Uploader::Base
  storage :aws

  attr_accessor :indice

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf docx png jpeg)
  end

end
