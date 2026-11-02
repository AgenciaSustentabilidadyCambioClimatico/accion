class AuditoriaValidacion < ApplicationRecord
  belongs_to :auditoria
  belongs_to :user

  serialize :validaciones, coder: YAML

  mount_uploader :archivo, ArchivoAuditoriaValidacionesUploader

end
