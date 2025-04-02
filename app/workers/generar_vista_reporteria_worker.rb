class GenerarVistaReporteriaWorker
  include Sidekiq::Job

    sidekiq_options retry: false, queue: "default", backtrace: true

    sidekiq_retries_exhausted do |msg|
      Sidekiq.logger.warn "Failed #{msg["class"]} with #{msg["args"]}: #{msg["error_message"]}"
    end

  def perform

  end
end
