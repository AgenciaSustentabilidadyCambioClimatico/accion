class AuditoriaElementoArchivo < ApplicationRecord
  mount_uploader :archivo, ArchivoInformeEvidenciaAuditoriasUploader
end
