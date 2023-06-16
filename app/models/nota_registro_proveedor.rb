class NotaRegistroProveedor < ApplicationRecord
  belongs_to :registro_proveedor
  belongs_to :manifestacion_de_interes
end
