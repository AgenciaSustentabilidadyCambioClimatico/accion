class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    # CarrierWave.clean_cached_files!
  end
end
