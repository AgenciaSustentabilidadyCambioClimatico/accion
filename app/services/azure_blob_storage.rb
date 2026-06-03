# frozen_string_literal: true

# Acceso directo a blobs (PDFs generados en FondoProduccionLimpia, descargas en controlador).
# CarrierWave usa la misma cuenta/contenedor vía config/initializers/carrierwave.rb.
class AzureBlobStorage
  class Error < StandardError; end
  class NotConfiguredError < Error; end
  class BlobNotFound < Error; end

  def self.upload(key, body, content_type: "application/pdf")
    new.upload(key, body, content_type: content_type)
  end

  def self.download(key)
    new.download(key)
  end

  def self.url(key)
    new.url(key)
  end

  def upload(key, body, content_type: nil)
    ensure_configured!
    file = directory.files.new(key: key, body: body)
    file.content_type = content_type if content_type
    file.public = AzureStorageFog.public_container?
    file.save
    url(key)
  end

  def download(key)
    ensure_configured!
    file = directory.files.get(key)
    raise BlobNotFound, key if file.nil? || file.body.nil?

    file.body
  end

  def url(key)
    ensure_configured!
    file = directory.files.get(key)
    raise BlobNotFound, key if file.nil?

    expiry = AzureStorageFog.url_expiry_seconds
    file.url(Time.now + expiry)
  end

  private

  def ensure_configured!
    return if AzureStorageFog.configured?

    raise NotConfiguredError, "Variables AZURE_STORAGE_* no configuradas"
  end

  def directory
    dir = AzureStorageFog.fog_directory
    raise NotConfiguredError, "Contenedor Azure no disponible" if dir.nil?

    dir
  end
end
