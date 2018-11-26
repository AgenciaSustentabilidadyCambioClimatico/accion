class Clasificacion < ApplicationRecord
	has_many :accion_clasificaciones, -> {includes :accion}, foreign_key: :clasificacion_id, dependent: :destroy
	has_many :materia_sustancia_clasificaciones, -> {includes :materia_sustancia}, foreign_key: :clasificacion_id, dependent: :destroy

	belongs_to :clasificacion_padre, class_name: :Clasificacion, foreign_key: :clasificacion_id, optional: true

	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates :referencia, presence: true
	validates :es_meta, presence: true, unless: -> { es_meta == false }

	def self.descritas(solo_metas=false)
		descripcion = {}
		record_set = solo_metas ? Clasificacion.where(es_meta: true).all : Clasificacion.all
		record_set.each do |clasificacion|
			descripcion[clasificacion.id] = {
				clasificacion_id: clasificacion.clasificacion_id,
				nombre: clasificacion.nombre,
				descripcion: clasificacion.descripcion,
				referencia: clasificacion.referencia,
				es_meta: clasificacion.es_meta, #redudante si solo_metas == true
			}
		end
		descripcion
	end

	def self.acciones_descritas
		descripcion = {}
		clasificaciones = Clasificacion.includes([:accion_clasificaciones]).where(es_meta: false).all
		clasificaciones.each do |clasificacion|
			descripcion[clasificacion.id] = clasificacion.accion_clasificaciones.map do |ac|
				accion = ac.accion
				{
					id: accion.id,
					nombre: accion.nombre,
					descripcion: accion.descripcion,
					meta_id: accion.meta_id,
					debe_asociar_materia_sustancia: accion.debe_asociar_materia_sustancia,
					medio_de_verificacion_generico: accion.medio_de_verificacion_generico
				}
			end
		end
		descripcion
	end

	def self.materia_sustancia_descritas
		descripcion = {}
		clasificaciones = Clasificacion.includes([:materia_sustancia_clasificaciones]).where(es_meta: false).all
		clasificaciones.each do |clasificacion|
			descripcion[clasificacion.id] = clasificacion.materia_sustancia_clasificaciones.map do |msc|
				ms = msc.materia_sustancia
				{
					id: ms.id,
	        meta_id: ms.meta_id,
	        unidad_base: ms.unidad_base, #DZC se corrige modificación en tabla materia sustancia
	        nombre: ms.nombre,
	        descripcion: ms.descripcion,
	        posee_una_magnitud_fisica_asociada: ms.posee_una_magnitud_fisica_asociada
				}
			end
		end
		descripcion
	end

	def self.por_padre(key=:name,object=false,include_parent=true)
		self.agrupar(
			Clasificacion.includes([:clasificacion_padre]).order(nombre: :asc, clasificacion_id: :asc).all,
			:clasificacion_id,
			:clasificacion_padre,
			key,
			object,
			include_parent
		)
	end
end