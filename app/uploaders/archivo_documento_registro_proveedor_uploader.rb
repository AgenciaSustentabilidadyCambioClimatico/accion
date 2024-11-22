class ArchivoDocumentoRegistroProveedorUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "accion/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf jpg png tiff zip rar doc docx)
  end

  def size_range
    1..200.megabytes
  end
end
