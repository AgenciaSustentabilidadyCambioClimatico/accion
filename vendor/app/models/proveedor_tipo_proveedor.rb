class ProveedorTipoProveedor < ApplicationRecord
	belongs_to :proveedor, optional: true
	belongs_to :tipo_proveedor

	validates :tipo_proveedor_id, presence: true
end
