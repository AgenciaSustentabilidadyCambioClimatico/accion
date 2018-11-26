class Convocatoria < ApplicationRecord
	belongs_to :flujo #cambiando dependencia desde manifestación de interes a flujo
	has_many :convocatoria_destinatarios, dependent: :destroy
	has_many :convocatoria_tipos
	has_one :minuta, dependent: :destroy 

	attr_accessor :accion #DZC permite pasar al modelo el nombre de la accion actual (comando REST)
	validate :direccion_en_mapa
	validates :nombre, :fecha, :direccion, :lat, :lng, :mensaje_encabezado, :mensaje_cuerpo, presence: true, on: :create #, unless: -> { bloque }
	validates :nombre, :fecha, :direccion, :lat, :lng, :mensaje_encabezado, :mensaje_cuerpo, presence: true, on: :update #, unless: -> { bloque }

	mount_uploaders :archivo_adjunto, ArchivoAdjuntosConvocatoriaUploader

	def self.ultima_convocatoria(fid, tc)
		self.where(flujo_id: fid).where(tarea_codigo: tc).order(fecha: :desc).all.first
	end

	def self.fecha_ultima_convocatoria(fid, tc)
		convocatoria=self.ultima_convocatoria(fid, tc)
		fecha=nil
		unless convocatoria.blank? 
			fecha=convocatoria.fecha
		end
		fecha
	end

	def self.caracterizacion_ultima_convocatoria(fid, tc)
		caracterizacion=nil
		unless fecha_ultima_convocatoria(fid, tc).nil?
			convocatoria=self.ultima_convocatoria(fid, tc)
			caracterizacion=convocatoria.caracterizacion
		end
		caracterizacion
	end

	def self.direccion_ultima_convocatoria(fid, tc)
		direccion=nil
		unless fecha_ultima_convocatoria(fid, tc).nil?
			convocatoria=self.ultima_convocatoria(fid, tc)
			direccion=convocatoria.direccion
		end
		direccion
	end

	def direccion_en_mapa
		if self.lat.blank? || self.lng.blank?
			errors.add(:direccion, "Debe ubicar la dirección en el mapa")
		end
	end

 	#DZC obtiene los destinatarios de la convocatoria desde el mapa de actores
	def destinatarios
		destinatarios = [] #destinatarios vienen desde mapa de actores.
		convocados = self.id_destinatarios_convocados
		actores = MapaDeActor.where(flujo_id: self.flujo_id).all
		actores.each do |actor|
			persona = actor.persona
			usuario = persona.user
			contribuyente = persona.contribuyente
			# DZC 2018-11-07 01:36:32 se agrega :convocado para desplegar el check en la vista
			destinatarios << {
				id: persona.id,
				nombre_completo: usuario.nombre_completo,
				rut: usuario.rut,
				institucion: contribuyente.razon_social,
				rut_institucion: contribuyente.rut_completo,
				rol: actor.rol.nombre,
				convocado: ((convocados.present? && convocados.include?(persona.id)) ? true : false)
			}
		end
		destinatarios=destinatarios.uniq #DZC elimina duplicados
	end

		# DZC 2018-11-07 01:24:28  revuelve un array con los persona_id de los usuarios que fueron convocados
	def id_destinatarios_convocados
		usuarios = []
		convocados = self.convocatoria_destinatarios
		usuarios += convocados.pluck(:destinatario_id) if convocados.present?
		usuarios = usuarios.uniq
	end

	def establece_mensaje_encabezado #DZC Genérico para todas las convocatorias
		flujo=self.flujo
		convocatoria_tipo = ConvocatoriaTipo.find_by(tarea_codigo: self.tarea_codigo)
		if !flujo.manifestacion_de_interes_id.blank?
			nombre_acuerdo = ManifestacionDeInteres.find(flujo.manifestacion_de_interes_id).nombre_acuerdo
		elsif !flujo.proyecto_id.blank?
			nombre_acuerdo = Proyecto.find(flujo.proyecto_id).nombre
		elsif !flujo.programa_proyecto_propuesta_id.blank?
			nombre_acuerdo = ProgramaProyectoPropuesta.find(flujo.programa_proyecto_propuesta_id).nombre_propuesta
		else
			nombre_acuerdo = 'Proceso sin nombre'
		end
		if ["new", "create", "nueva_convocatoria"].include? self.accion #DZC revisa si es una nueva convocatoria o es modificacion de una existente
			comienzo_encabezado = "Invitación a reunión para la etapa de '#{convocatoria_tipo.descripcion}', en '#{nombre_acuerdo}'" 
		else
			comienzo_encabezado = "Modifica reunión titulada '#{self.nombre}', para fecha '#{self.fecha}'"
		end
		self.mensaje_encabezado = "#{comienzo_encabezado}"
	end

	def establece_mensaje_cuerpo #DZC Genérico para todas las convocatorias
		if ["new", "create", "nueva_convocatoria"].include? self.accion #DZC revisa si es una nueva convocatoria o es modificacion de una existente
			comienzo_cuerpo = "se le ha invitado a participar en una reunión."
		else
			comienzo_cuerpo = "se ha modificado la reunión titulada '#{self.nombre}', originalmente programada para realizarse el día '#{self.fecha}', en '#{self.direccion}'.\n 
			El mensaje anterior que usted recibió con motivo de esta reunión es el siguiente: \n
			#{self.mensaje_cuerpo}. \n
			"
		end
		self.mensaje_cuerpo = "Estimado señor(a), #{comienzo_cuerpo}"
	end

end
