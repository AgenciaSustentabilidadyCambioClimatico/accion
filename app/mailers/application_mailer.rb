class ApplicationMailer < ActionMailer::Base
  queue_as :mailers
  default from: ENV["MAILER_DEFAULT_OPTIONS_FROM"]
  layout 'mailer'

  after_action :interceptor

  # Reintenta automáticamente hasta 5 veces si el servidor SMTP tarda en responder o corta la conexión
  retry_on Net::ReadTimeout, Net::OpenTimeout, Errno::ECONNRESET, wait: :polynomially_longer, attempts: 5 do |job, exception|
    Rails.logger.error "=== ERROR TIMEOUT SMTP DEFINITIVO (tras 5 intentos) ==="
    Rails.logger.error "Job: #{job.class.name} | Args: #{job.arguments.inspect}"
    Rails.logger.error "Error: #{exception.class} - #{exception.message}"
    Rails.logger.error "======================================================"
  end

  # Captura errores propios del protocolo SMTP (respuestas 4xx / 5xx del servidor)
  rescue_from Net::SMTPError, Net::SMTPServerBusy, Net::SMTPUnknownError do |exception|
    Rails.logger.error "=== ERROR SMTP DETECTADO ==="
    Rails.logger.error "Mailer: #{self.class.name}"
    Rails.logger.error "Destinatario: #{message.to}"
    Rails.logger.error "Asunto: #{message.subject}"
    Rails.logger.error "Error: #{exception.message}"
    Rails.logger.error "Backtrace: #{exception.backtrace.first(5).join("\n")}"
    Rails.logger.error "================================"
  end

  private

  def interceptor
    if %w[stag dev].include?(ENV["AMBIENTE"])
      logger.info { "Modificando destinatario email..." }
      message.subject = "#{ENV["AMBIENTE"]}: (#{message.try(:to).try(:first).to_s}) #{message.subject}"
      message.to = "dev@ascc.cl"
    end
  end
end