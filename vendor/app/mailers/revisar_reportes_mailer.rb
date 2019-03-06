class RevisarReportesMailer < ApplicationMailer
	def enviar(flujo, persona, url, registro = nil)
		
		titulo = "ASCC Sistemas: Modificaciones realizadas en auditorías"
		@message = "Estimado señor #{persona.user.nombre_completo}, ASCC Sistemas le informa que es posible que se hayan realizado modificaciones en los resultados de sus auditorías para el instrumento '#{flujo.nombre_para_raa}', auditorías que puede revisar en el siguiente enlace:"
		@registro = registro
		@url = url
    mail(to: persona.email_institucional, subject: titulo)
  end
end
