class MinutaMailer < ApplicationMailer
	def enviar(minuta_participante, archivos)
    @message =minuta_participante.format_cuerpo
    #crea la variable archivos iterando sobre ella y obteniendo los archivos adjuntos.
    archivos.each do |archivo| 
        attachments[archivo.identifier]= File.read(archivo.current_path) #adiciona el archivo adjunto	
    end
    mail(to: minuta_participante.destinatario.email_institucional, subject: minuta_participante.format_titulo)
  end
end
