class AuditoriaNivel < ApplicationRecord

  belongs_to :auditoria
  belongs_to :estandar_nivel
  validates :plazo, presence: true

end
