# frozen_string_literal: true

namespace :carrierwave do
  desc "Pasos orientativos para copiar objetos desde S3 a Azure Blob conservando la misma clave (path) que CarrierWave"
  task s3_to_azure_notes: :environment do
    puts <<~TEXT

      Objetivo: las claves en el contenedor Azure deben coincidir con las del bucket S3
      (p. ej. accion/public/uploads/fondo_produccion_limpia/pdf/..., accion/public/uploads/<model>/...).

      1) Inventario en S3 (prefijo accion/public/uploads/).
      2) Copia conservando rutas, por ejemplo con AzCopy (requiere credenciales S3 y Azure):

         azcopy copy \\
           'https://<S3_ACCESS_KEY>:<S3_SECRET_KEY>@s3.<region>.amazonaws.com/<bucket>/accion/public/uploads' \\
           'https://<ACCOUNT>.blob.core.windows.net/<container>/accion/public/uploads' \\
           --recursive

         Ajustar URL de origen/destino según documentación actual de AzCopy para S3 y Blob.

      3) Tras el cutover, validar en la app: descargas, .url en PDFs/mailers y adjuntos masivos.

      Variables de la app: ver config/carrierwave_azure.env.sample

    TEXT
  end
end
