class ConvocatoriaMailer < ApplicationMailer
  def enviar(convocatoria_destinatario, encabezado, cuerpo, archivos, registro = nil)
    @message = cuerpo
    @registro = registro

    # Iteramos sobre el listado de archivos/adjuntos
    Array(archivos).each do |item|
      next if item.blank?

      # Detectar si 'item' es un registro de ActiveRecord o el Uploader directo
      uploader = item.respond_to?(:archivo) ? item.archivo : item
      next unless uploader.present? && (uploader.file.present? rescue false)

      nombre_archivo = uploader.identifier.presence || (uploader.file.filename rescue "adjunto")

      # 1. Leemos los bytes binarios directamente desde el almacenamiento backend
      # (Sin hacer peticiones HTTP con URI.open que fallan en Azure)
      file_data = begin
                    uploader.read
                  rescue StandardError => e
                    Rails.logger.warn "Falló uploader.read, intentando AzureBlobStorage: #{e.message}"
                    AzureBlobStorage.download(uploader.store_path) if defined?(AzureBlobStorage)
                  end

      if file_data.present?
        content_type = uploader.content_type.presence || 
                       Rack::Mime.mime_type(File.extname(nombre_archivo), 'application/octet-stream')
        
        # 2. Adjuntamos los bytes al correo
        attachments[nombre_archivo] = { 
          mime_type: content_type, 
          content: file_data 
        }
      end
    end

    mail(to: convocatoria_destinatario.destinatario.email_institucional, subject: encabezado)
  end
end