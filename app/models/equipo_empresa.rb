class EquipoEmpresa < ApplicationRecord
  belongs_to :flujo
  belongs_to :contribuyente, optional: true
end
