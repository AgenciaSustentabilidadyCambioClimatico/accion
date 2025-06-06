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
    end
  end

	def self.metodos(user, reunion=nil, mdi=nil)
		{
			"[asunto]": "Mensaje de salida",
			"[nombre]": user.nombre_completo,
			"[telefono]": user.telefono,
			"[email]": user.email,
			"[rut]": user.rut,
			"[fecha_reunion]": reunion.nil? ? "[fecha_reunion]" : reunion.fecha,
			"[lugar_reunion]": reunion.nil? ? "[lugar_reunion]" : reunion.direccion,
			"[nombre_acuerdo]": mdi.nil? ? '[nombre_acuerdo]' : mdi.nombre_acuerdo
		}
	end

	def responsables tipo_instrumento
		Responsable.__personas_responsables(self.rol_destinatarios.reject{|m| m.empty?}, tipo_instrumento_id)
	end

	def continuar_flujo flujo_id, extra = {}, sin_destinatario = false
		
		unless self.sin_salida
			sig_tarea = self.tarea_salida 

			# DZC 2018-10-11 12:00:27 nulifica el contenido de 'extra' para el caso de que tarea actual sea convocatoria y tarea siguiente no lo sea. Esto por que en algunos momentos se hace necesario terminar todas las tareas asociadas a la misma convocatoria, y de no nulificarse el campo se terminarían tambien otras tareas que no deben terminarse así.
			extra = {} if ((self.tarea_entrada.es_convocatoria? && !self.tarea_salida.es_minuta?) || (self.tarea_entrada.es_convocatoria? && !!self.tarea_salida.es_convocatoria?))

			if sin_destinatario
				tp = TareaPendiente.find_or_create_by({
					flujo_id: flujo_id, 
					tarea_id: sig_tarea.id, 
					estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, 
					user_id: nil, 
					data: extra,
					persona_id: nil
				})
			else
				flujo = Flujo.find(flujo_id)
				
				if sig_tarea.cualquiera_con_rol_o_usuario_asignado
									 
					#DZC en realidad si este booleano es true, se deberia enviar la tarea solo a los usuarios contenidos en el mapa de actores que posean el rol escogido por el administrador en el mantenedor de tareas
					
					#si tarea es encuesta, utiliza los roles adiocionales de ejecución
					roles_ids = self.rol_destinatarios
					roles_sig_tarea = [sig_tarea.rol_id]
					if sig_tarea.es_una_encuesta
						roles_ids += sig_tarea.encuesta_ejecucion_roles.pluck(:rol_id)
					end
					MapaDeActor.where(flujo_id: flujo_id).where(rol_id: roles_ids).each do |actor| #DZC modificado para que asigne la tarea a cada actor contenido en el mapa de actores
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
									
									if (roles_sig_tarea.include?(actor.rol_id))
										
										tp = TareaPendiente.find_or_create_by({
											flujo_id: flujo_id, 
											tarea_id: sig_tarea.id, 
											estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, 
											user_id: actor.persona.user_id, 
											data: extra,
											persona_id: actor.persona.id
									})
									end
									if ((!self.mensaje_salida_asunto.blank?) && (!self.mensaje_salida_cuerpo.blank?) && (self.tarea_entrada.codigo != Tarea::COD_FPL_006) && !(sig_tarea.codigo == Tarea::COD_APL_032 && !tp.new_record?))
										rgc = RegistroAperturaCorreo.create(user_id: actor.persona.user.id, flujo_tarea_id: self.id, fecha_envio_correo: DateTime.now, flujo_id: flujo_id)
										
										begin
											mdi = flujo.manifestacion_de_interes
										rescue
											mdi = nil
										end
                   						puts 'enviado mail segunda vez'
										
										FlujoMailer.enviar(
											self.asunto_format(actor.persona.user, mdi), 
											self.cuerpo_format(actor.persona.user, mdi), 
											actor.persona.email_institucional, 
											rgc.id).deliver_now
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
									begin
										mdi = flujo.manifestacion_de_interes
									rescue
										mdi = nil
									end
                  puts 'Enviando mails 1 ves'
									FlujoMailer.enviar(
										self.asunto_format(ut.user,mdi), 
										self.cuerpo_format(ut.user,mdi), 
										ut.email_institucional,
										rgc.id).deliver_now #DZC 2018-10-05 13:12:23 se agrega id para efectos instanciar la ruta a la imágen asociada al registro del receptor del corren en tabla RegistroAperturaCorreo
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
	end

	def asunto_format user,mdi=nil
		asunto = self.mensaje_salida_asunto
		FlujoTarea.metodos(user,nil,mdi).each do |key, value|
			asunto = asunto.gsub(key.to_s, value.to_s)
		end
		asunto
	end

	def cuerpo_format user,mdi=nil
		cuerpo = self.mensaje_salida_cuerpo
		FlujoTarea.metodos(user,nil,mdi).each do |key, value|
			cuerpo = cuerpo.gsub(key.to_s, value.to_s)
		end
		cuerpo
	end

end
