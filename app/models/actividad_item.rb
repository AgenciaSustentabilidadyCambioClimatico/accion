class ActividadItem < ApplicationRecord

	mount_uploaders :archivos_tecnica, ArchivosActividadItemUploader
	mount_uploaders :archivos_respaldo, ArchivosActividadItemUploader

	belongs_to :proyecto_actividad, :inverse_of => :actividad_item
	belongs_to :glosa
	belongs_to :tipo_aporte
	belongs_to :estado_tecnica, class_name: "EstadoRendicion", foreign_key: "estado_tecnica_id"
	belongs_to :estado_respaldo, class_name: "EstadoRendicion", foreign_key: "estado_respaldo_id"

	validates :nombre, presence: true
	validates :monto, presence: true

	attr_accessor :fecha_realizacion_compromiso, :gb_id, :modificado, :nuevo

	def item_success tarea_pendiente, finalizado
		
		flujo_tareas = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).where("tarea_salida_id <> ?", Tarea::ID_FPL_014).all
		flujo_tareas.each do |ft|
			ft.continuar_flujo tarea_pendiente.flujo_id
		end
		if finalizado

			ft = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).where(tarea_salida_id: Tarea::ID_FPL_014).first
			ft.continuar_flujo tarea_pendiente.flujo_id, {encuesta_id: ft.tarea_salida.encuesta_id}
		end
	end

	def esta_rendido_o_en_proceso?
		( self.estado_tecnica_id != EstadoRendicion::NO_ENVIADA )
	end
	
end