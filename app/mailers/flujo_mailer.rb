class FlujoMailer < ApplicationMailer
	def enviar(titulo,cuerpo,email, registro = nil)
    @message = cuerpo
    @registro = registro
    mail(to: email, subject: titulo)
  end
end
