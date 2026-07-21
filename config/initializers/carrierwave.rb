# frozen_string_literal: true

CarrierWave.configure do |config|
  config.cache_storage = :file

  azure_in_dev = Rails.env.development? && ActiveModel::Type::Boolean.new.cast(ENV["AZURE_STORAGE_USE_IN_DEV"])
  use_fog = !Rails.env.test? && (!Rails.env.development? || azure_in_dev)

  unless use_fog
    config.storage = :file
    next
  end

  unless AzureStorageFog.configured?
    if use_fog && !Rails.env.development?
      raise "CarrierWave Azure: defina AZURE_STORAGE_ACCOUNT_NAME, AZURE_STORAGE_ACCESS_KEY y AZURE_STORAGE_CONTAINER"
    end

    config.storage = :file
    next
  end

  AzureStorageFog.load_dependencies!

  config.storage = :fog
  config.fog_credentials = {
    provider: "AzureRM",
    azure_storage_account_name: ENV["AZURE_STORAGE_ACCOUNT_NAME"],
    azure_storage_access_key: ENV["AZURE_STORAGE_ACCESS_KEY"],
    environment: ENV.fetch("AZURE_STORAGE_ENVIRONMENT", "AzureCloud")
  }
  config.fog_directory = ENV["AZURE_STORAGE_CONTAINER"]
  config.fog_public = AzureStorageFog.public_container?
  config.fog_authenticated_url_expiration = AzureStorageFog.url_expiry_seconds
  config.fog_attributes = {
    "Cache-Control" => "max-age=#{365.days.to_i}"
  }
end
