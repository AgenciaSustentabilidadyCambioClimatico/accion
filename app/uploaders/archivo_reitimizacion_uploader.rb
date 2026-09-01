class ArchivoReitimizacionUploader < CarrierWave::Uploader::Base
  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf docx doc xlsx xls zip)
  end
end