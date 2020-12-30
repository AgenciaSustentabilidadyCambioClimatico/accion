class Minuta < ApplicationRecord
	# has_one :convocatoria
	belongs_to :convocatoria

	validates :fecha, :direccion, :lat, :lng,  :mensaje_encabezado, :mensaje_cuerpo, presence: true, on: :update #, unless: -> { bloque }
	validate :direccion_en_mapa
	validate :acta, :lista_asistencia, on: :update, unless: -> {self.convocatoria.tarea_codigo == Tarea::COD_APL_021} #DZC necesario para condiciones de flujo 'A' y 'B' en APL-022
	#validate :acta, on: :update, if: -> {self.convocatoria.tarea_codigo != Tarea::COD_APL_021 && self.convocatoria.tarea_codigo == Tarea::COD_APL_022}

	mount_uploader :lista_asistencia, ArchivoListaAsistenciaMinutaUploader
	mount_uploader :acta, ArchivoActaMinutaUploader

	#DZC 2018-10-26 12:56:14 devuelve el listado de archivos como array
	# def get_archivos
	# 	
	# 	archivos = []
	# 	self.acta = [self.acta] if !self.acta.is_a?(Array)
	# 	self.lista_asistencia = [self.lista_asistencia] if !self.lista_asistencia.is_a?(Array)
	# 	archivos += self.acta
	# 	archivos += self.lista_asistencia
	# 	archivos
	# end

	def convocados
		convocados = [] #destinatarios vienen desde mapa de actores.
		asistieron = self.id_usuarios_que_asistieron
		convocatoria=Convocatoria.find(self.convocatoria_id)
		actores = MapaDeActor.where(flujo_id: convocatoria.flujo_id, persona_id: convocatoria.convocatoria_destinatarios.pluck(:destinatario_id)).all
		actores.each do |actor|
			persona = actor.persona
			usuario = persona.user
			contribuyente = persona.contribuyente
			# DZC 2018-10-31 17:49:04 se agrega :asistio para desplegar el check en la vista
			convocados << {
				id: persona.id,
				nombre_completo: usuario.nombre_completo,
				rut: usuario.rut,
				institucion: contribuyente.razon_social,
				rut_institucion: contribuyente.rut_completo,
				rol: actor.rol.nombre,
				asistio: ((asistieron.present? && asistieron.include?(persona.id)) ? true : false)
			}
		end
		convocados=convocados.uniq #DZC elimina duplicados
	end

	# DZC 2018-10-31 18:07:14 revuelve un array con los persona_id de los usuarios que asistieron a la convocatoria
	def id_usuarios_que_asistieron
		usuarios = []
		convocatoria=Convocatoria.find(self.convocatoria_id)
		asistentes = convocatoria.convocatoria_destinatarios.where(asistio: true)
		usuarios += asistentes.pluck(:destinatario_id)  if asistentes.present?
		usuarios = usuarios.uniq
	end

	def establece_mensaje_encabezado
		convocatoria=self.convocatoria
		flujo=convocatoria.flujo
		convocatoria_tipo = ConvocatoriaTipo.find_by(tarea_codigo: convocatoria.tarea_codigo)
		if !flujo.manifestacion_de_interes_id.blank?
			nombre_acuerdo = ManifestacionDeInteres.find(flujo.manifestacion_de_interes_id).nombre_acuerdo
		elsif !flujo.proyecto_id.blank?
			nombre_acuerdo = Proyecto.find(flujo.proyecto_id).nombre
		elsif !flujo.programa_proyecto_propuesta_id.blank?
			nombre_acuerdo = ProgramaProyectoPropuesta.find(flujo.programa_proyecto_propuesta_id).nombre_propuesta
		else
			nombre_acuerdo = 'Proceso sin nombre'
		end
		self.mensaje_encabezado = "Documentos relativos a la reunión titulada '#{convocatoria_tipo.descripcion}', realizada con fecha '#{self.fecha}', en #{nombre_acuerdo}'"
	end

	def establece_mensaje_cuerpo
		acta=self.acta.blank? ? '': self.acta.file.path.split('/').last
		lista=self.lista_asistencia.blank? ? '': self.lista_asistencia.file.path.split('/').last
		self.mensaje_cuerpo = "Se adjuntan los siguientes documentos: \n 
			#{acta}\n
			#{lista}\n
		"
	end

	def direccion_en_mapa
		if self.lat.blank? || self.lng.blank?
			errors.add(:direccion, "Debe ubicar la dirección en el mapa")
		end
	end

	#obtiene los archivos a bajar
	def self.get_archivos
		descargables = {}
		tarea.descargable_tareas.each do |desc|
			descargables[desc.codigo] = { nombre: desc.nombre, args: [tarea,desc] }
		end
		descargables
  end
end
