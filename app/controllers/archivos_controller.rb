class ArchivosController < ApplicationController
  def descargar
    # 1. Cambiamos .classify por .camelize para evitar el error 'limpia' -> 'Limpium'
    nombre_modelo = params[:modelo].camelize
    modelo_class = nombre_modelo.safe_constantize
    
    objeto = modelo_class&.find_by(id: params[:id]) if modelo_class

    unless objeto
      Rails.logger.error "=== ARCHIVO ERROR: No se encontró el registro (Modelo intentado: #{nombre_modelo}, ID: #{params[:id]}) ==="
      return render plain: "Archivo o registro no encontrado", status: :not_found
    end

    # 2. Obtenemos el uploader/campo del archivo
    campo = params[:campo]
    archivo = objeto.send(campo) rescue nil

    if archivo.present? && (archivo.file.present? rescue false)
      nombre_archivo = (archivo.file.filename rescue nil) || (archivo.path.split('/').last rescue "documento.pdf")

      # 3. Descargamos el binario desde Azure y lo enviamos al navegador
      send_data archivo.read,
                filename: nombre_archivo,
                disposition: 'attachment'
    else
      Rails.logger.error "=== ARCHIVO ERROR: El campo '#{campo}' está vacío en #{nombre_modelo} ##{objeto.id} ==="
      redirect_back fallback_location: root_path, alert: "El archivo adjunto no se encuentra disponible."
    end
  rescue => e
    Rails.logger.error "=== ERROR CRÍTICO DESCARGA AZURE: #{e.message} ==="
    Rails.logger.error e.backtrace.join("\n")
    redirect_back fallback_location: root_path, alert: "Ocurrió un error al intentar descargar el archivo desde Azure."
  end
end