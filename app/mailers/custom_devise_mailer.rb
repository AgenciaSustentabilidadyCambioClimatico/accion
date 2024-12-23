class CustomDeviseMailer < Devise::Mailer
  # Inherit from ApplicationMailer to include the interceptor
  default from: 'guillo@mailing.com'
  layout 'mailer'

  after_action :interceptor

  def interceptor
    if %w[stag dev].include?(ENV["AMBIENTE"])
      logger.info { "Modificando destinatario email..." }
      message.subject = "#{ENV["AMBIENTE"]}: (#{message.try(:to).try(:first).to_s}) #{message.subject}"
      message.to = "dev@ascc.cl"
    end
  end
end
