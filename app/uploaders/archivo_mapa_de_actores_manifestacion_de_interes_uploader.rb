class ArchivoMapaDeActoresManifestacionDeInteresUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
  	@name ||= "#{timestamp}-mapa_de_actores.xlsx" if original_filename.present? and super.present?
  end

	def timestamp
    var = :"@#{mounted_as}_timestamp"
    # model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
    model.instance_variable_get(var) or model.instance_variable_set(var, DateTime.now.strftime('%Y%m%d%H%M%S').to_i)
  end

  def extension_whitelist
    %w(xlsx)
  end

end
