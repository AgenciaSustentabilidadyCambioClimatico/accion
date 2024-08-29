class ArchivoCopiaInstrumentoNombreRepresentantePostulanteFondoProduccionLimpiaUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf jpg png tiff zip rar doc docx)
  end

  def size_range
    1..200.megabytes
  end

end