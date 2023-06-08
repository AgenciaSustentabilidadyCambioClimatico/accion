class DocumentoRegistroProveedor < ApplicationRecord
  belongs_to :registro_proveedor

  mount_uploader :archivo, ArchivoCertificadoProveedorUploader

  validates :archivo,  presence: true
end
