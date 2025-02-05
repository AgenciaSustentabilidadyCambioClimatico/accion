require 'open-uri'

class ConvocatoriaMailer < ApplicationMailer
  def enviar(convocatoria_destinatario, encabezado, cuerpo, archivos, registro = nil)
  	@message = cuerpo
  	# Representa el id de la tabla registro_apertura_correos asociado al mail
  	@registro = registro
  	#DZC crea la variable archivos iterando sobre ella y obteniendo los archivos adjuntos.
  	archivos.each do |archivo|
      if archivo.present? && archivo.url.present?
        signed_url = archivo.url # Generate signed URL for private S3 files
        file_data = URI.open(signed_url).read
        attachments[archivo.identifier] = { mime_type: archivo.content_type, content: file_data }
      end
  	end
  	mail(to: convocatoria_destinatario.destinatario.email_institucional, subject: encabezado)
  end
end
