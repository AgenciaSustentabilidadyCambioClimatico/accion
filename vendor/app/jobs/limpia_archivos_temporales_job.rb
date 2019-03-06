class LimpiaArchivosTemporalesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    CarrierWave.clean_cached_files!
  end
end
