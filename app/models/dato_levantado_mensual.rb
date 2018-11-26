class DatoLevantadoMensual < ApplicationRecord
	mount_uploader :nombre_archivo_evidencia, ArchivosAnexosInformeAcuerdosUploader
	#validates :nombre_archivo_evidencia, presence: :true
	validates :fecha_levantamiento, presence: :true
	validates :rut_levantador, presence: :true
	validates :unidad_declarada, presence: :true
	validates :mes, presence: :true
	validates :mes, numericality: {only_integer: true}
	validates :año, presence: :true
	validates :año, numericality: {only_integer: true}
	validates :tipo_de_valor, presence: :true
	validates :valor, presence: :true
	validate :unidad_compatible
	validate :archivo_valido
	validate :fecha_valida

	belongs_to :dato_productivo_elemento_adherido

	def unidad_compatible
		if self.dato_productivo_elemento_adherido.present?
			
			unidades = []
			unidades += self.dato_productivo_elemento_adherido.dato_recolectado.unidades_compatibles
			#Ahora es posible seleccionar la unidad base tambien.-
			unidades << self.dato_productivo_elemento_adherido.dato_recolectado.unidad_base
			unless unidades.include? unidad_declarada
				errors.add(:unidades_compatibles, "Unidad no compatible")
			end
		end		
	end
	def archivo_valido
		if nombre_archivo_evidencia.file.nil?
			errors.add(:archivo_invalido, "Archivo no encontrado")
		end
	end
  def fecha_valida
    if (DateTime.parse(fecha_levantamiento) rescue false)
      errors.add(:fecha_invalida, "Formato de fecha invalida")
    end
  end
end
