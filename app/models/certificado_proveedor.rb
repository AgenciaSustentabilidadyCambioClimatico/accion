class CertificadoProveedor < ApplicationRecord
  belongs_to :registro_proveedor
  belongs_to :materia_sustancia
  belongs_to :actividad_economica
end
