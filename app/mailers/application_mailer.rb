class ApplicationMailer < ActionMailer::Base
  default from: 'mailing@binarybag.com'
  layout 'mailer'
  after_action :interceptor

  def interceptor
    if %w[stag dev].include?(Rails.configuration.ambiente)
      Rails.logger.info "Modifying email recipient for environment: #{Rails.configuration.ambiente}"

      original_recipient = message.to.try(:first) || "unknown"
      message.subject = "#{Rails.configuration.ambiente.upcase}: (#{original_recipient}) #{message.subject}"
      message.to = "sistemas@ascc.cl"
    end
  end
end
