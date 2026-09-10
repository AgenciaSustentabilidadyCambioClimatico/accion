# frozen_string_literal: true

# Carga fog-azurerm y dependencias vendoreadas en gitlab-fog-azure-rm (mismo patrón que intranet2).
module AzureStorageFog
  module_function

  def load_dependencies!
    gem_root = Gem.loaded_specs["gitlab-fog-azure-rm"]&.full_gem_path ||
               Gem::Specification.find_by_name("gitlab-fog-azure-rm").full_gem_path
    %w[vendor/azure-storage-ruby/common/lib vendor/azure-storage-ruby/blob/lib].each do |rel|
      dir = File.join(gem_root, rel)
      $LOAD_PATH.unshift(dir) if File.directory?(dir) && !$LOAD_PATH.include?(dir)
    end
    require "fog/azurerm"
  end

  def configured?
    ENV["AZURE_STORAGE_ACCOUNT_NAME"].present? &&
      ENV["AZURE_STORAGE_ACCESS_KEY"].present? &&
      ENV["AZURE_STORAGE_CONTAINER"].present?
  end

  def fog_connection
    load_dependencies! unless defined?(Fog::Storage)
    Fog::Storage.new(
      provider: "AzureRM",
      azure_storage_account_name: ENV["AZURE_STORAGE_ACCOUNT_NAME"],
      azure_storage_access_key: ENV["AZURE_STORAGE_ACCESS_KEY"],
      environment: ENV.fetch("AZURE_STORAGE_ENVIRONMENT", "AzureCloud")
    )
  end

  def fog_directory
    fog_connection.directories.get(ENV["AZURE_STORAGE_CONTAINER"])
  end

  def public_container?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch("AZURE_STORAGE_PUBLIC_CONTAINER", "false"))
  end

  def url_expiry_seconds
    ENV.fetch("AZURE_STORAGE_URL_EXPIRY", "1800").to_i
  end
end
