class DocumentoProveedorExtra < ApplicationRecord
  belongs_to :registro_proveedor

  mount_uploader :archivo, ArchivoDocumentoProveedorExtraUploader
end
