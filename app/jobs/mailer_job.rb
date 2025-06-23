class MailerJob < ApplicationJob
  queue_as :mailers

  def perform(mailer_class, method_name, *args)
    # Obtener el número de correos enviados en los últimos 60 segundos
    current_count = Rails.cache.increment("email_send_count", 1, expires_in: 60.seconds)
    
    # Si es el primer correo, no hay delay
    # Si es el segundo o más, calcular delay basado en el contador
    if current_count > 1
      delay_seconds = [current_count - 1, 60].min  # Máximo 60 segundos de delay
      Rails.logger.info "Email ##{current_count} - Delay de #{delay_seconds} segundos"
      sleep(delay_seconds) unless Rails.env.test?
    end
    
    # Enviar el correo
    mailer_class.constantize.send(method_name, *args).deliver_now
    
    Rails.logger.info "Email enviado exitosamente: #{mailer_class}##{method_name}"
  rescue Net::SMTPError, Net::SMTPServerBusy, Net::SMTPUnknownError => e
    Rails.logger.error "Error SMTP en MailerJob: #{e.message}"
    raise e
  end
end 