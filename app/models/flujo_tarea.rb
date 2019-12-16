class FlujoTarea < ApplicationRecord
	belongs_to :tarea_entrada, class_name: :Tarea
	belongs_to :tarea_salida, class_name: :Tarea, optional: true

	validates :tarea_entrada_id, presence: true
	validates :condicion_de_salida, presence: true
	validates :rol_destinatarios, presence: true
	validates :mensaje_salida_asunto, presence: true, if: -> { mensaje_salida_cuerpo.present? }
	validates :mensaje_salida_cuerpo, presence: true, if: -> { mensaje_salida_asunto.present? }

	serialize :rol_destinatarios

	before_validation :check_rol_destinatarios


	def check_rol_destinatarios
		roles = rol_destinatarios.reject { |r| r.empty? }
		if roles.blank?
			errors.add(:rol_destinatarios, "Debe indicar al menos un rol")
		else
			condicion = nil
			condicion = "id = #{tarea_entrada_id}" if tarea_entrada_id.present?
			condicion += "#{(condicion.blank?) ? '' : ' OR '}id = #{tarea_salida_id}" if tarea_salida_id.present?
			unless condicion.nil?
				tareas = Tarea.where(condicion).all
				roles_encontrados = []
				tareas.each do |t|
					roles_encontrados << t.rol_id if roles.map{|r|r.to_i}.include?(t.rol_id)
				end
				if roles_encontrados.blank?
					errors.add(:rol_destinatarios, "Debe indicar también los roles #{tareas.map{|t|t.rol.nombre}.join(' y ')}");
				elsif tareas.size == 2 && roles_encontrados.size == 1
					errors.add(:rol_destinatarios, "Debe indicar también el rol #{tareas.map{|t|t.rol.nombre if ( t.rol_id == (tareas.map{|t|t.rol_id}-roles_encontrados).first )}.compact.join('')}")
				end
			end
		end
	end

	def self.metodos(user, reunion=nil)
		{
			"[asunto]": "Mensaje de salida",
			"[nombre]": user.nombre_completo,
			"[telefono]": user.telefono,
			"[email]": user.email,
			"[rut]": user.rut,
			"[fecha_reunion]": reunion.nil? ? "[fecha_reunion]" : reunion.fecha,
			"[lugar_reunion]": reunion.nil? ? "[lugar_reunion]" : reunion.direccion
		}
	end

	def responsables tipo_instrumento
		Responsable.__personas_responsables(self.rol_destinatarios.reject{|m| m.empty?}, tipo_instrumento_id)
	end

	def continuar_flujo flujo_id, extra = {}
		
		unless self.sin_salida
			sig_tarea = self.tarea_salida 

			# DZC 2018-10-11 12:00:27 nulifica el contenido de 'extra' para el caso de que tarea actual sea convocatoria y tarea siguiente no lo sea. Esto por que en algunos momentos se hace necesario terminar todas las tareas asociadas a la misma convocatoria, y de no nulificarse el campo se terminarían tambien otras tareas que no deben terminarse así.
			extra = {} if ((self.tarea_entrada.es_convocatoria? && !self.tarea_salida.es_minuta?) || (self.tarea_entrada.es_convocatoria? && !!self.tarea_salida.es_convocatoria?))

			if sig_tarea.cualquiera_con_rol_o_usuario_asignado
								 
				#DZC en realidad si este booleano es true, se deberia enviar la tarea solo a los usuarios contenidos en el mapa de actores que posean el rol escogido por el administrador en el mantenedor de tareas
				
				MapaDeActor.where(flujo_id: flujo_id).where(rol_id: sig_tarea.rol_id).each do |actor| #DZC modificado para que asigne la tarea a cada actor contenido en el mapa de actores
					#DZC obtiene los id de auditorias para instanciar idéntica cantidad de tareas   pendientes si se trata de tarea siguiente APL-032
					
					auditorias = []
					if sig_tarea.codigo == Tarea::COD_APL_032
						Auditoria.where(flujo_id: flujo_id).each do |a|
							auditorias << {auditoria_id: a.id}
						end
					end 
					repeticiones = auditorias.blank? ? 1 : auditorias.size
					unless actor.nil?
						#DZC agrega un loop para la creación de tantas tareas pendientes APL-032, como auditorias del flujo existan 
						(1..repeticiones).each do |r|
							
							unless ((sig_tarea.codigo == Tarea::COD_APL_032) && auditorias.blank?)
								extra = auditorias.blank? ? extra : auditorias.last
								tp = TareaPendiente.find_or_create_by({
									flujo_id: flujo_id, 
									tarea_id: sig_tarea.id, 
									estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, 
									user_id: actor.persona.user_id, 
									data: extra,
									persona_id: actor.persona.id
								})
								if ((!self.mensaje_salida_asunto.blank?) && (!self.mensaje_salida_cuerpo.blank?) && (self.tarea_entrada.codigo != Tarea::COD_FPL_006) && !(sig_tarea.codigo == Tarea::COD_APL_032 && !tp.new_record?))
									rgc = RegistroAperturaCorreo.create(user_id: actor.persona.user.id, flujo_tarea_id: self.id, fecha_envio_correo: DateTime.now, flujo_id: flujo_id)

									FlujoMailer.delay.enviar(
										self.asunto_format(actor.persona.user), 
										self.cuerpo_format(actor.persona.user), 
										actor.persona.email_institucional, 
										rgc.id)
								end
							end
							 
							if !auditorias.blank? #DZC elimina el último elemento del array
								auditorias.pop
							end
						end
					end
				end    
			else
				responsables = sig_tarea.responsables
				responsables.each do |ut|
					#DZC obtiene los id de auditorias para instanciar idéntica cantidad de tareas   pendientes si se trata de tarea siguiente APL-032
					
					auditorias = []
					if sig_tarea.codigo == Tarea::COD_APL_032
						Auditoria.where(flujo_id: flujo_id).each do |a|
							auditorias << {auditoria_id: a.id}
						end
					end
					repeticiones = auditorias.blank? ? 1 : auditorias.size 
					(1..repeticiones).each do |r|
						
						unless ((sig_tarea.codigo == Tarea::COD_APL_032) && auditorias.blank?)
							extra = auditorias.blank? ? extra : auditorias.last
							tp = TareaPendiente.find_or_create_by({
								flujo_id: flujo_id, 
								tarea_id: sig_tarea.id, 
								estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, 
								user_id: ut.user_id, 
								data: extra,
								persona_id: ut.id 
							})
							# MapaDeActor.find_or_create_by({
							# 	flujo_id: flujo_id, 
							# 	rol_id: sig_tarea.rol_id, 
							# 	persona_id: ut.id
							# })
							if ((!self.mensaje_salida_asunto.blank?) && (!self.mensaje_salida_cuerpo.blank?) && (self.tarea_entrada.codigo != Tarea::COD_FPL_006) && !(sig_tarea.codigo == Tarea::COD_APL_032 && !tp.new_record?))
								rgc = RegistroAperturaCorreo.create(user_id: ut.user_id, flujo_tarea_id: self.id, fecha_envio_correo: DateTime.now, flujo_id: flujo_id)

								FlujoMailer.delay.enviar(
									self.asunto_format(ut.user), 
									self.cuerpo_format(ut.user), 
									ut.email_institucional,
									rgc.id) #DZC 2018-10-05 13:12:23 se agrega id para efectos instanciar la ruta a la imágen asociada al registro del receptor del corren en tabla RegistroAperturaCorreo
							end
						end   
						if !auditorias.blank? #DZC elimina el último elemento del array
							auditorias.pop
						end
					end
				end
			end
		end
	end

	def asunto_format user
		asunto = self.mensaje_salida_asunto
		FlujoTarea.metodos(user).each do |key, value|
			asunto = asunto.gsub(key.to_s, value.to_s)
		end
		asunto
	end

	def cuerpo_format user
		cuerpo = self.mensaje_salida_cuerpo
		FlujoTarea.metodos(user).each do |key, value|
			cuerpo = cuerpo.gsub(key.to_s, value.to_s)
		end
		cuerpo
	end

end