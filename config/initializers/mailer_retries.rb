Rails.application.config.to_prepare do
  ActionMailer::MailDeliveryJob.retry_on(
    Net::ReadTimeout,
    Net::OpenTimeout,
    Errno::ECONNRESET,
    wait: :polynomially_longer,
    attempts: 5
  ) do |job, exception|
    Rails.logger.error "=== ERROR TIMEOUT SMTP DEFINITIVO (tras 5 intentos) ==="
    Rails.logger.error "Job: #{job.class.name} | Args: #{job.arguments.inspect}"
    Rails.logger.error "Error: #{exception.class} - #{exception.message}"
    Rails.logger.error "======================================================"
  end
end