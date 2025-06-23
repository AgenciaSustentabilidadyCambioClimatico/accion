class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILER_DEFAULT_OPTIONS_FROM"]
  layout 'mailer'

  after_action :interceptor

  rescue_from Net::SMTPError, Net::SMTPServerBusy, Net::SMTPUnknownError do |exception|
    Rails.logger.error "=== ERROR SMTP DETECTADO ==="
    Rails.logger.error "Mailer: #{self.class.name}"
    Rails.logger.error "Método: #{caller_locations(1,1)[0].label}"
    Rails.logger.error "Destinatario: #{message.to}"
    Rails.logger.error "Asunto: #{message.subject}"
    Rails.logger.error "Error: #{exception.message}"
    Rails.logger.error "Backtrace: #{exception.backtrace.first(5).join("\n")}"
    Rails.logger.error "================================"
  end

  def interceptor
    if %w[stag dev].include?(ENV["AMBIENTE"])
      logger.info { "Modificando destinatario email..." }
      message.subject = "#{ENV["AMBIENTE"]}: (#{message.try(:to).try(:first).to_s}) #{message.subject}"
      message.to = "dev@ascc.cl"
    end
  end

  # Sobrescribir el método de envío para usar circuit breaker
  def deliver_now
    SmtpCircuitBreaker.call do
      # NO usar sleep aquí para evitar bloquear el thread principal
      super
    end
  end

  # Sobrescribir deliver_later para incluir delay automático
  def deliver_later
    # Usar delay automático de 1 segundo
    MailerJob.set(wait: 1.second).perform_later(self.class.name, message_method_name, *args)
  end
end
