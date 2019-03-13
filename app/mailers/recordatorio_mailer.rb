class RecordatorioMailer < ApplicationMailer

	def enviar(to,subject,message)
    @message = message
    mail(to: to, subject: subject)
  end
end