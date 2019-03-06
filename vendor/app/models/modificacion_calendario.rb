class ModificacionCalendario < ApplicationRecord
	serialize :atributos_proyecto
	serialize :atributos_proyecto_actividades
	serialize :atributos_rendiciones

	def self.agregar_proyecto_vacio(id)
		proyecto = self.find_or_create_by({proyecto_id: id})
		proyecto.update({
			atributos_proyecto: {},
			atributos_proyecto_actividades: [],
			atributos_rendiciones: []
		})
	end

	def find_proyecto_actividad(id)
		item = {}
		unless self.atributos_proyecto_actividades.blank?
			self.atributos_proyecto_actividades.each do |i|
				if i.with_indifferent_access["gb_id"] == id.to_i
					item = i
				end
			end
		end
		item
	end

	def self.bloquear_actividades_e_items(proyecto_id,proyecto_actividad_id,item)
		mc = ModificacionCalendario.where(proyecto_id: proyecto_id).first
		unless mc.blank? || mc.atributos_proyecto_actividades.blank?
			mc.atributos_proyecto_actividades.each do |apa|
				if apa['gb_id'] == proyecto_actividad_id
					apa['en_revision'] = true
					apa[:actividad_item_attributes].each do |aia|
						if aia['gb_id'] == item.id
							aia[:estado_tecnica_id]		= item.estado_tecnica_id
							aia[:estado_respaldo_id]	= item.estado_respaldo_id
							#aia[:archivos_tecnica]		= item.archivos_tecnica
							#aia[:archivos_respaldo]		= item.archivos_respaldo
						end
					end 
				end
			end
			if mc.changed?
				mc.save
			end
		end
	end
end
