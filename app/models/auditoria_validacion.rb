class AuditoriaValidacion < ApplicationRecord
  belongs_to :auditoria
  belongs_to :user

  serialize :validaciones

  mount_uploader :archivo, ArchivoAuditoriaValidacionesUploader

end
