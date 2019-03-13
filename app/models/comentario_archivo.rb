class ComentarioArchivo < ApplicationRecord
	mount_uploader :archivo, ArchivoComentarioUploader

	belongs_to :comentario, optional: true
	validates :archivo, presence: true
end