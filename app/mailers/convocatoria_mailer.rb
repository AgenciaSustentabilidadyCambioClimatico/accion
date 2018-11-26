class ConvocatoriaMailer < ApplicationMailer
  def enviar(convocatoria_destinatario, encabezado, cuerpo, archivos, registro = nil)
    @message = cuerpo
    # Representa el id de la tabla registro_apertura_correos asociado al mail
    @registro = registro
    #DZC crea la variable archivos iterando sobre ella y obteniendo los archivos adjuntos.
    archivos.each do |archivo| 
        attachments[archivo.identifier]= File.read(archivo.current_path) #adiciona el archivo adjunto	
    end
    mail(to: convocatoria_destinatario.destinatario.email_institucional, subject: encabezado)
  end
end
