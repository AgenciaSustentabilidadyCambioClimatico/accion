class HitoDePrensaArchivo < ApplicationRecord
	mount_uploader :archivo, ArchivoParaHitoDePrensaUploader

	belongs_to :hito_de_prensa, optional: true
	validates :archivo, presence: true

	#validate :file_size
	#before_validation :asignar_nombre

	MAX_FILE_SIZE = (1024*1024*2) # 2 megasbytes

	def asignar_nombre
		
	end

	def file_size
		if self.archivo.size >= self::MAX_FILE_SIZE
			errors.add(:archivo, "El tamaño del archivo excede el permitido")
		end
	end
end