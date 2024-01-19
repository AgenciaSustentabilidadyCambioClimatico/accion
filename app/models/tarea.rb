class Tarea < ApplicationRecord
	# DZC 2019-07-15 11:28:38 se agrega relación con tabla 'campo_tooltips'
	has_many :campo_tareas, dependent: :delete_all
	has_many :campos, through: :campo_tareas
	has_many :encuesta_descarga_roles
	has_many :encuesta_ejecucion_roles
  has_many :registro_proveedor_mensajes

	# DOSSA 18-07-2019 se agrega para los recursos anidados de campos
	accepts_nested_attributes_for :campos

	accepts_nested_attributes_for :encuesta_descarga_roles, allow_destroy: true
	accepts_nested_attributes_for :encuesta_ejecucion_roles, allow_destroy: true

	belongs_to :tipo_instrumento, -> { includes :tipo }
	belongs_to :rol
	belongs_to :encuesta, optional: true
	belongs_to :flujo, optional: true
	has_many :pendientes, -> { includes [:flujo] }, class_name: :TareaPendiente
	has_many :descargable_tareas, dependent: :destroy 
	
	#validates :etapa_id, presence: true
	validates :tipo_instrumento_id, presence: true
	validates :rol_id, presence: true
	validates :codigo, presence: true, format: { with: /\A(APL|PPF|FPL|PRO)-[\0-9]\d{1,3}(\.[0-9])?\Z/ }
	validates :nombre, presence: true
	validates :descripcion, presence: true

	validates :es_una_encuesta, presence: true, unless: -> { es_una_encuesta == false }
	validates :encuesta_id, presence: true, if: -> { es_una_encuesta == true }

	validates :recordatorio_tarea_asunto, presence: true, if: -> { recordatorio_tarea_frecuencia.present? ||recordatorio_tarea_cuerpo.present? }
	validates :recordatorio_tarea_cuerpo, presence: true, if: -> { recordatorio_tarea_asunto.present? ||recordatorio_tarea_frecuencia.present? }
	validates :recordatorio_tarea_frecuencia, presence: true, if: -> { recordatorio_tarea_asunto.present? ||recordatorio_tarea_cuerpo.present? }

	#validates :posee_formulario, presence: true
	#validates :cualquiera_con_rol_o_usuario_asignado, presence: true
	#validates :condicion_de_acceso, presence: true

	validate :frecuencia

	attr_accessor :limitar_duracion

	before_save :check_encuesta_data
	after_commit :update_crontab

	# AON: no se sabe si será obligatorio
	# validate :dias_duracion, if: -> { posee_formulario == true}

	def check_encuesta_data
		if !self.es_una_encuesta
			self.encuesta_id = nil
			self.encuesta_descarga_roles.destroy_all
		end
	end

  def get_descargables

    descargables = {}
    self.descargable_tareas.each do |desc|
      if ((desc.archivo.path.present? && File.exist?(desc.archivo.path)) || (!desc.subido && desc.contenido.present?))
        descargables[desc.codigo] = { nombre: desc.nombre, args: [id,desc.id] } 
      end
    end
    descargables
  end

	def dias_duracion
		if(self.duracion == '' || self.duracion.nil?)
			# por ahora no es obligatorio
			# errors.add(:duracion,'Debe indicar cantidad de días de duracion')
		elsif(self.duracion < 10 || self.duracion > 70)
			errors.add(:duracion,'Debe ser entre 10 y 70 días')
		end
	end

	#DZC se agrega para efecto de determinar si se requiere revisión de la tarea en mapa de actores (y futuros posibles usos)
	def requiere_revision?
		![Tarea::COD_APL_018, Tarea::COD_APL_020, Tarea::COD_APL_021, Tarea::COD_APL_023, Tarea::COD_APL_037].include?(self.codigo)
	end

	def necesita_notificacion?
		( ! recordatorio_tarea_asunto.blank? && ! recordatorio_tarea_asunto.blank? && ! recordatorio_tarea_cuerpo.blank? )
	end

	def metodos(o,mdi=nil)
		metodos = {
			"[nombre]": o.nombre_completo,
			"[telefono]": o.telefono, 
			"[email]": o.email, 
			"[rut]": o.rut,
			"[nombre_acuerdo]": mdi.nil? ? '[nombre_acuerdo]' : mdi.nombre_acuerdo
		}
	end

  def update_crontab
  	##
		# DZC 2019-08-23 20:16:40
		# se modifica para el uso de la gema whenever, incluyendo el uso de dockers (pero sin impactar el 
		# despliegue sin dockers)
		ambiente = (Rails.env.to_s || "development" )
  	%x{whenever --update-crontab #{ambiente} --set "environment=#{ambiente}&bundle_command=bundle exec" >> "#{Rails.root}/log/whenever_error_#{ambiente}.log" 2>&1}

  # 	__crontab = "#{Rails.root}/tmp/__#{Time.now.to_i}_tareas_crontab"
  # 	%x{crontab -r}
  # 	%x{crontab -l > #{__crontab}}
  # 	Tarea.all.each do |tarea|
  # 		unless tarea.recordatorio_tarea_frecuencia.blank?
  # 			ambiente = Rails.env.production? ? "production" : "development"
  # 			comando = "/bin/bash -l -c 'cd #{Rails.root} && RAILS_ENV=#{ambiente} bundle exec rails ascc:notificador_de_tareas_pendientes[#{tarea.id}] --silent >> #{Rails.root}/log/crontab_recordatorios.log 2>&1'"
  # 			%x{echo "#{tarea.recordatorio_tarea_frecuencia} #{comando}" >> #{__crontab} }
  # 		end
  # 	end
  # 	# DZC 2018-11-22 11:37:22 se agrega a crontab la eliminación de los temporales de carrierwave via rake task ascc:limpia_cache_carrierwave
		# # %x{/bin/bash -l -c 'cd #{Rails.root} && RAILS_ENV=#{Rails.env.production? ? :production : :development} bundle exec rails ascc:agrega_limpia_cache_carrierwave_a_crontab --silent'}  	
  # 	comando = "/bin/bash -l -c 'cd #{Rails.root} && RAILS_ENV=#{Rails.env.production? ? :production : :development} bundle exec rails ascc:limpia_cache_carrierwave --silent >> #{Rails.root}/log/limpia_cache_carrierwave.log 2>&1'"
  # 	%x{echo "#{'0 3 * * *'} #{comando}" >> #{__crontab} }

  # 	%x{crontab #{__crontab}}
  # 	%x{rm #{__crontab}}
  end

	def frecuencia
		unless self.recordatorio_tarea_frecuencia.blank?
			message_error = "Recuerde que debe indicar 5 valores, puede utilizar asteriscos para todos los casos o especificar lo siguiente: #{I18n.t(:cron_list)}"
			begin
				array = recordatorio_tarea_frecuencia.split(" ").reject{|r|r.empty?}
				if array.size > 5
					#self.recordatorio_tarea_frecuencia = (array.size > 5 ? array.slice(0,5) : array ).join(" ")
					errors.add(:recordatorio_tarea_frecuencia,message_error)
				else
					##
					# DZC 2019-08-23 21:30:43
					# se corrige caso de que se agregue un espacio al final del string
					verificado = verify_crontab_line(self.recordatorio_tarea_frecuencia+" dummy_command_for_validation")
					self.recordatorio_tarea_frecuencia = verificado.split(" dummy_command_for_validation")[0]
				end
			rescue
				errors.add(:recordatorio_tarea_frecuencia,message_error)
			end
		end
	end
	
	def responsables
		#DZC DEBE ELIMINARSE Y BUSCAR EL INSTRUMENTO DESDE LA INSTANCIA DE FLUJO ESPECIFICA (manifestación, ppp, ppf) 

		# DZC se modifica para obtener todos los instrumentos  
		# instrumentos_id=[]
		# instrumento_base_id = self.tipo_instrumento.tipo_instrumento_id.blank? ? self.tipo_instrumento.id : self.tipo_instrumento.tipo_instrumento_id
		# instrumentos_id = TipoInstrumento.where(tipo_instrumento_id: instrumento_base_id).pluck(:id)
		# instrumentos_id << instrumento_base_id
		roles_ids = [self.rol_id]
		if self.es_una_encuesta
			roles_ids += self.encuesta_ejecucion_roles.pluck(:rol_id)
		end
		
	  Responsable.__personas_responsables(roles_ids, self.tipo_instrumento.id)
	end

	def puedo_ver user, flujo_id
		puedo = false
		if !self.cualquiera_con_rol_o_usuario_asignado
			self.responsables.each do |r|
				if r.user.id == user.id
					puedo = true
					break
				end
			end
		else
			MapaDeActor.where(flujo_id: flujo_id).where(rol_id: self.rol_id).each do |actor|
				puedo = true if actor.persona.user_id = user.id
			end
		end
		puedo
	end

	#DZC devuelve los responsables por tarea y flujo
	def responsables_de_la_tarea flujo_id
		responsables_id = [] 
		TareaPendiente.where(flujo_id: flujo_id, tarea_id: self.id).each do |tp|
			responsables_id << tp.user_id if !tp.user_id.blank?
		end
		responsables = []
		responsables = User.where(id: responsables_id.uniq).pluck(:nombre_completo).sort if !responsables_id.blank?
		responsables
	end

	#DZC para determinacion de historial de instrumentos
	def es_convocatoria?
		[Tarea::ID_APL_011, Tarea::ID_APL_016, Tarea::ID_APL_030, Tarea::ID_PPF_014].include? self.id #DZC se excluyen APL-021 y APL-037, pues se programaron con controlador y vistas distintas de las genéricas
	end

	##DZC para determinacion de historial de instrumentos
	def es_minuta?
		[Tarea::ID_APL_012, Tarea::ID_APL_017, Tarea::ID_APL_022, Tarea::ID_APL_031, Tarea::ID_APL_038, Tarea::ID_PPF_015].include? self.id 
	end

	#DZC para determinacion de historial de instrumentos
	def es_encuesta?
		[Tarea::ID_APL_015, Tarea::ID_APL_039, Tarea::ID_APL_043, Tarea::ID_PPF_023, Tarea::ID_PPF_024].include? self.id 
	end

	#DZC para determinacion de historial de instrumentos
	def es_auditoria?
		[Tarea::ID_APL_032,Tarea::ID_APL_032_1, Tarea::ID_APL_033, Tarea::ID_APL_034, Tarea::ID_PPF_021, Tarea::ID_PPF_022].include? self.id 
	end


	#DZC APLs
	ID_APL_001			=	1		# -	APL-001-Completar Manifestación de Interés
	ID_APL_002			=	30	# - APL-002-Asignar Revisor
	ID_APL_003_1		=	34	# - APL-003.1-Revisar Admisibilidad tecnica Manifestación de Interés
	ID_APL_003_2		=	94	# - APL-003.2-Revisar Admisibilidad juridica Manifestación de Interés
	ID_APL_004_1		=	36	# - APL-004.1-Resolver Observaciones Admisibilidad tecnica Manifestación de Interés
	ID_APL_004_2		=	36	# - APL-004.2-Resolver Observaciones Admisibilidad juridica Manifestación de Interés
	ID_APL_005			=	39	# - APL-005-Revisar Pertinencia y Factibilidad Manifestación de Interés
	ID_APL_006			=	41	# - APL-006-Responder Condiciones u Observaciones Factibilidad y Pertinencia Manifestación de Interés
	ID_APL_007			=	44	# - APL-007-Cargar Hito de Prensa
	ID_APL_008			=	46	# - APL-008-Asignar Usuario a Cargo de Entregables Diagnóstico General
	ID_APL_011			= 57  # - APL-011-Preparar Convocatoria Taller o Reunión
	ID_APL_012			= 58  # - APL-012-Elaborar y Cargar Minuta, Acta y Asistencia
	ID_APL_013			= 63  # - APL-013-Cargar/Actualizar Entregables Diagnóstico General
	ID_APL_014			= 66  # - APL-014-Revisar Entregables Diagnóstico General 
	ID_APL_015			= 67  # - APL-015-Contestar Encuesta Diagnóstico General
	ID_APL_016			= 69  # - APL-016-Convocar Negociación o Indicar paso a firma
	ID_APL_017			= 72  # - APL-017-Elaborar y Cargar Acta o Minuta y Asistencia
	ID_APL_018			= 71  # - APL-018- Actualizar Acuerdo, Mapa de Actores
	ID_APL_019			= 70  # - APL-019- Contestar Evaluación y Consulta Proceso Negociación
	ID_APL_020			= 68  # - APL-020- Actualizar Cambios en Acuerdo, Mapa de Actores, Responder Observaciones
	ID_APL_021			= 65  # - APL-021- Actualizar Mapa de Actores, Realizar Convocatoria Firma
	ID_APL_022			= 62  # - APL-022- Cargar Acuerdo con Todas las Firmas
	ID_APL_023			= 61  # - APL-023- Actualizar Miembros Comité Coordinador y Acuerdo
	ID_APL_024			= 60  # - APL-024- Asignar Usuario a Cargar Entregables y Cargar Datos Empresas
	ID_APL_025			= 59  # - APL-025- Solicitar Adhesión, Admisión y Certificación
	ID_APL_025_1		= 97  # - APL-025.1- Solicitar Adhesión, Admisión y Certificación no logueado
	ID_APL_025_2		= 98  # - APL-025.2- Solicitar Adhesión, Admisión y Certificación logueado sin empresas sin ser parte de proceso
	ID_APL_025_3		= 99  # - APL-025.3- Solicitar Adhesión, Admisión y Certificación loqgueado con empresa sin ser parte de proceso
	ID_APL_026			= 56  # - APL-026- Notificar Cierre Procesos Acuerdos
	ID_APL_027			= 55  # - APL-027- Elaborar y enviar reporte automatizado de Avance
	ID_APL_028			= 54  # - APL-028- Aprobar Adhesión, Admisión y Certificación
	ID_APL_029			= 52  # - APL-029- Cargar Datos Productivos Asociados a Elemento a Certificar
	ID_APL_030			= 51  # - APL-030- Preparar Convocatoria Comité Coordinador
	ID_APL_031			= 50  # - APL-031- Elaborar y Cargar Acta o Minuta y Asistencia
	ID_APL_032			= 48  # - APL-032- Cargar Datos para Auditoría
	ID_APL_032_1		= 100  # - APL-032- Cargar Datos para Auditoría
	ID_APL_033			= 47  # - APL-033- Revisar Auditoría y Otorgar Certificado si no hay validación
	ID_APL_034			= 45  # - APL-034- Validar Auditoría y otorgar certificados si validaciones coinciden
	ID_APL_037			= 40  # - APL-037- Actualizar Mapa Actores, Convocar Ceremonia Certificación
	ID_APL_038			= 45  # - APL-038- Indicar Ceremonia Realizada
	ID_APL_039			= 45  # - APL-039- Contestar Evaluación y Consulta de Proceso Implementación
	ID_APL_040  		= 35  # - APL-040-Asignar Responsable Elaborar Informe de Impacto
	ID_APL_041  		= 33  # - APL-041-Elaborar informe de impacto
	ID_APL_042  		= 31  # - APL-042-Revisar informe de impacto
	ID_APL_043  		= 32  # - APL-043- Contestar Evaluación y Consulta Proceso Implementación
	ID_APL_044  		= 96  # - APL-043- Contestar Evaluación y Consulta Proceso Implementación

	COD_APL_001			=	'APL-001'	 #[1}		-	APL-001-Completar Manifestación de Interés
	COD_APL_002			=	'APL-002'	 #[30}	-	APL-002-Asignar Revisor
	COD_APL_003_1		=	'APL-003.1'	 #[34}	-	APL-003.1-Revisar Admisibilidad tecnica Manifestación de Interés
	COD_APL_003_2		=	'APL-003.2'	 #[34}	-	APL-003.2-Revisar Admisibilidad juridica Manifestación de Interés
	COD_APL_004_1		=	'APL-004.1'	 #[36}	-	APL-004.1-Resolver Observaciones Admisibilidad tecnica Manifestación de Interés
	COD_APL_004_2		=	'APL-004.2'	 #[36}	-	APL-004.2-Resolver Observaciones Admisibilidad juridica Manifestación de Interés
	COD_APL_005			=	'APL-005'	 #[39}	-	APL-005-Revisar Pertinencia y Factibilidad Manifestación de Interés
	COD_APL_006			=	'APL-006'	 #[41}	-	APL-006-Responder Condiciones u Observaciones Factibilidad y Pertinencia Manifestación de Interés
	COD_APL_007			=	'APL-007'	 #[44}	-	APL-007-Cargar Hito de Prensa
	COD_APL_008			=	'APL-008'	 #[46}	-	APL-008-Asignar Usuario a Cargo de Entregables Diagnóstico General
	COD_APL_009			=	'APL-009'	 #[46}	- APL-009-Actualizar Mapa de Actores Acuerdo
	COD_APL_010			=	'APL-010'	 #[46}	-	APL-010-Revisar Mapa de Actores Acuerdo
	COD_APL_011			=	'APL-011'	 #[57}	-	APL-011-Preparar Convocatoria Taller o Reunión
	COD_APL_012			=	'APL-012'	 #[58}	-	APL-012-Elaborar y Cargar Minuta, Acta y Asistencia
	COD_APL_013			=	'APL-013'	 #[63}	-	APL-013-Cargar/Actualizar Entregables Diagnóstico General
	COD_APL_014			=	'APL-014'	 #[66}	-	APL-014-Revisar Entregables Diagnóstico General
	COD_APL_015			=	'APL-015'	 #[67}	-	APL-015-Contestar Encuesta Diagnóstico General
	COD_APL_016			=	'APL-016'	 #[69}	-	APL-016-Convocar Negociación o Indicar paso a firma
	COD_APL_017			=	'APL-017'	 #[72}	-	APL-017-Elaborar y Cargar Acta o Minuta y Asistencia
	COD_APL_018			=	'APL-018'	 #[71}	-	APL-018- Actualizar Acuerdo, Mapa de Actores
	COD_APL_019			=	'APL-019'	 #[70}	-	APL-019- Contestar Evaluación y Consulta Proceso Negociación
	COD_APL_020			=	'APL-020'	 #[68}	- APL-020- Actualizar Cambios en Acuerdo, Mapa de Actores, Responder Observaciones
	COD_APL_021			=	'APL-021'	 #[65}	-	APL-021- Actualizar Mapa de Actores, Realizar Convocatoria Firma
	COD_APL_022			=	'APL-022'	 #[62}	-	APL-022- Cargar Acuerdo con Todas las Firmas
	COD_APL_023			=	'APL-023'	 #[61}	-	APL-023- Actualizar Miembros Comité Coordinador y Acuerdo
	COD_APL_024			=	'APL-024'	 #[60}	-	APL-024- Asignar Usuario a Cargar Entregables y Cargar Datos Empresas
	COD_APL_025			=	'APL-025'	 #[59}	-	APL-025- Solicitar Adhesión, Admisión y Certificación
	COD_APL_025_1		=	'APL-025.1'	 #[59}	-	APL-025.1- Solicitar Adhesión, Admisión y Certificación
	COD_APL_027			=	'APL-027'	 #[55}	-	APL-027- Elaborar y enviar reporte automatizado de Avance
	COD_APL_028			=	'APL-028'	 #[54}	-	APL-028- Aprobar Adhesión, Admisión y Certificación
	COD_APL_029			=	'APL-029'	 #[52}	-	APL-029- Cargar Datos Productivos Asociados a Elemento a Certificar
	COD_APL_030			=	'APL-030'	 #[51}	-	APL-030- Preparar Convocatoria Comité Coordinador
	COD_APL_031			=	'APL-031'	 #[50}	-	APL-031- Elaborar y Cargar Acta o Minuta y Asistencia
	COD_APL_032			=	'APL-032'	 #[48}	-	APL-032- Cargar Datos para Auditoría
	COD_APL_032_1		=	'APL-032.1'	 #[48}	-	APL-032- Cargar Datos para Auditoría
	COD_APL_033			=	'APL-033'	 #[47}	-	APL-033- Revisar Auditoría y Otorgar Certificado si no hay validación
	COD_APL_034			=	'APL-034'	 #[45}	-	APL-034- Validar Auditoría y otorgar certificados si validaciones coinciden
	COD_APL_037			=	'APL-037'	 #[40}	-	APL-037- Actualizar Mapa Actores, Convocar Ceremonia Certificación
	COD_APL_038			=	'APL-038'	 #[38}	-	APL-038- Indicar Ceremonia Realizada
	COD_APL_039			=	'APL-039'	 #[37}	-	APL-039- Contestar Evaluación y Consulta de Proceso Implementación
	COD_APL_040			=	'APL-040'	 #[35}	- APL-040- Asignar Responsable Elaborar Informe de Impacto
	COD_APL_041			=	'APL-041'	 #[33}	-	APL-041- Elaborar Informe de Impacto
	COD_APL_042			=	'APL-042'	 #[31}	-	APL-042- Revisar Informe de Impacto
	COD_APL_043			=	'APL-043'	 #[32}	-	APL-043- Contestar Evaluación y Consulta Proceso Implementación
	COD_APL_044			=	'APL-044'	 #[32}	-	APL-043- Contestar Evaluación y Consulta Proceso Implementación
	
	#DZC FPLs
 	ID_FPL_001	=	2		# -	FPL-001-Revisar registro postulaciones y cargar nuevos proyectos 
	ID_FPL_002	=	4		# -	FPL-002-Iniciar seguimiento de proyectos
	ID_FPL_003	=	7		# -	FPL-003-Gestionar y registrar garantías y endosos
	ID_FPL_004	=	8		# -	FPL-004-Revisar plazos y montos
	ID_FPL_005	=	9		# -	FPL-005-Designar responsables
	ID_FPL_006	=	10	# -	FPL-006-Agendar reunión con beneficiario y encargados entregables
	ID_FPL_007	=	12	# -	FPL-007-Calendarizar rendiciones y carga de respaldo.
	ID_FPL_008	=	13	# -	FPL-008-Solicitar pago
	ID_FPL_009	=	14	# -	FPL-009-Ingresar N° orden de pago
	ID_FPL_010	=	15	# -	FPL-010-Ingresar fecha de pago
	ID_FPL_011	=	16	# -	FPL-011-Enviar rendición
	ID_FPL_012	=	17	# -	FPL-012-Revisar técnicamente rendición de actividades
	ID_FPL_013	=	18	# -	FPL-013-Verificación contable
	ID_FPL_014	=	19	# -	FPL-014-Responder Encuestas
	ID_FPL_015	=	3		# -	FPL-015-Propone modificación de calendario
	ID_FPL_016	=	5		# -	FPL-016-Aprueba y/o realiza modificación de calendario
	ID_FPL_017	=	11	# -	FPL-017-Cargar resolución con contrato que aprueba modificación
	ID_FPL_018	=	6		# -	FPL-018-Ingreso datos restitución

	COD_FPL_001	=	'FPL-001'	 #[2}		-	FPL-001-Revisar registro postulaciones y cargar nuevos proyectos 
	COD_FPL_002	=	'FPL-002'	 #[4}		-	FPL-002-Iniciar seguimiento de proyectos
	COD_FPL_003	=	'FPL-003'	 #[7}		-	FPL-003-Gestionar y registrar garantías y endosos
	COD_FPL_004	=	'FPL-004'	 #[8}		-	FPL-004-Revisar plazos y montos
	COD_FPL_005	=	'FPL-005'	 #[9}		-	FPL-005-Designar responsables
	COD_FPL_006	=	'FPL-006'	 #[10}	-	FPL-006-Agendar reunión con beneficiario y encargados entregables
	COD_FPL_007	=	'FPL-007'	 #[12}	-	FPL-007-Calendarizar rendiciones y carga de respaldo.
	COD_FPL_008	=	'FPL-018'	 #[13}	-	FPL-008-Solicitar pago
	COD_FPL_009	=	'FPL-009'	 #[14}	-	FPL-009-Ingresar N° orden de pago
	COD_FPL_010	=	'FPL-010'	 #[15}	-	FPL-010-Ingresar fecha de pago
	COD_FPL_011	=	'FPL-011'	 #[16}	-	FPL-011-Enviar rendición
	COD_FPL_012	=	'FPL-012'	 #[17}	-	FPL-012-Revisar técnicamente rendición de actividades
	COD_FPL_013	=	'FPL-013'	 #[18}	-	FPL-013-Verificación contable
	COD_FPL_014	=	'FPL-014'	 #[19}	-	FPL-014-Responder Encuestas
	COD_FPL_015	=	'FPL-015'	 #[3}		-	FPL-015-Propone modificación de calendario
	COD_FPL_016	=	'FPL-016'	 #[5}		-	FPL-016-Aprueba y/o realiza modificación de calendario
	COD_FPL_017	=	'FPL-017'	 #[11}	-	FPL-017-Cargar resolución con contrato que aprueba modificación
	COD_FPL_018	=	'FPL-018'	 #[6}		-	FPL-018-Ingreso datos restitución

	#DZC PPFs
	ID_PPF_001	=	20	# -	PPF-001-Formular proyecto
	ID_PPF_002	=	23	# -	PPF-002-Designar revisor
	ID_PPF_003	=	24	# -	PPF-003-Revisar Propuesta
	ID_PPF_004	=	25	# -	PPF-004-Resolver observaciones propuesta programa / proyecto
	ID_PPF_005	=	26	# -	PPF-005-Subir carta de apoyo
	ID_PPF_006	=	27	# -	PPF-006-Dar seguimiento a proyecto externo
	ID_PPF_007	=	28	# -	PPF-007-Elaborar Propuesta
	ID_PPF_008	=	29	# -	PPF-008-Observaciones Técnicas
	ID_PPF_009	=	74	#	-	PPF-009-Ingreso de datos postulación
	ID_PPF_010	=	75	#	-	PPF-010-Seguimiento Proyecto Ejecutado por Terceros
	ID_PPF_011	=	76	#	-	PPF-011-Asignar usuarios a Cargo Ejecución Programa
	ID_PPF_012	=	77	#	-	PPF-012-Datos Ejecución Presupuestaria Anual
	ID_PPF_013	=	78	#	-	PPF-013-Agenda
	ID_PPF_014	=	79	#	-	PPF-014-Preparar Convocatoria
	ID_PPF_015	=	80	#	-	PPF-015-Elaborar y Cargar Minuta, Acta y Asistencia.
	ID_PPF_016	=	81	#	-	PPF-016-Atención Directa a Empresas
	ID_PPF_017	=	82	#	-	PPF-017- Aprobar Adhesión a Programa
	ID_PPF_018	=	83	#	-	PPF-018-Cargar Actividades a Realizar en Empresa
	ID_PPF_019	=	84	#	-	PPF-019-Revisar Plan
	ID_PPF_020	=	85	#	-	PPF-020-Cargar Datos Productivos Asociados a Participantes	
	ID_PPF_021	=	86	#	-	PPF-021-Cargar Resultados Seguimiento por Participante
	ID_PPF_022	=	87	#	-	PPF-022-Revisar Auditoría
	ID_PPF_023	=	22	# -	PPF-023-Encuesta de mitad de Ejecución
	ID_PPF_024	=	21	# -	PPF-024-Responder Encuesta final sobre ejecución programa/proyecto

	COD_PPF_001	=	'PPF-001'	 #[20}	-	PPF-001-Formular proyecto
	COD_PPF_002	=	'PPF-002'	 #[23}	-	PPF-002-Designar revisor
	COD_PPF_003	=	'PPF-003'	 #[24}	-	PPF-003-Revisar Propuesta
	COD_PPF_004	=	'PPF-004'	 #[25}	-	PPF-004-Resolver observaciones propuesta programa / proyecto
	COD_PPF_005	=	'PPF-005'	 #[26}	-	PPF-005-Subir carta de apoyo
	COD_PPF_006	=	'PPF-006'	 #[27}	-	PPF-006-Dar seguimiento a proyecto externo
	COD_PPF_007	=	'PPF-007'	 #[28}	-	PPF-007-Elaborar Propuesta
	COD_PPF_008	=	'PPF-008'	 #[29}	-	PPF-008-Observaciones Técnicas
	COD_PPF_009	=	'PPF-009'	 #[74}	-	PPF-009-Ingreso de datos postulación
	COD_PPF_010	=	'PPF-010'	 #[75}	-	PPF-010-Seguimiento Proyecto Ejecutado por Terceros
	COD_PPF_011	=	'PPF-011'	 #[76}	-	PPF-011-Asignar usuarios a Cargo Ejecución Programa
	COD_PPF_012	=	'PPF-012'	 #[77}	-	PPF-012-Datos Ejecución Presupuestaria Anual
	COD_PPF_013	=	'PPF-013'	 #[78}	-	PPF-013-Agenda
	COD_PPF_014	=	'PPF-014'	 #[79}	-	PPF-014-Preparar Convocatoria
	COD_PPF_015	=	'PPF-015'	 #[80}	-	PPF-015-Elaborar y Cargar Minuta, Acta y Asistencia.
	COD_PPF_016	=	'PPF-016'	 #[81}	-	PPF-016-Atención Directa a Empresas
	COD_PPF_017	=	'PPF-017'	 #[82}	-	PPF-017- Aprobar Adhesión a Programa
	COD_PPF_018	=	'PPF-018'	 #[83}	-	PPF-018-Cargar Actividades a Realizar en Empresa
	COD_PPF_019	=	'PPF-019'	 #[84}	-	PPF-019-Revisar Plan
	COD_PPF_020	=	'PPF-020'	 #[85}	-	PPF-020-Cargar Datos Productivos Asociados a Participantes	
	COD_PPF_021	=	'PPF-021'	 #[86}	-	PPF-021-Cargar Resultados Seguimiento por Participante
	COD_PPF_022	=	'PPF-022'	 #[87}	-	PPF-022-Revisar Auditoría
	COD_PPF_023	=	'PPF-023'	 #[88}	-	PPF-023-Encuesta de mitad de Ejecución					
	COD_PPF_024	=	'PPF-024'	 #[21}	-	PPF-024-Responder Encuesta final sobre ejecución programa/proyecto	

  COD_PRO_001 = 'PRO-001'	
  COD_PRO_002 = 'PRO-002'  #[02}  - PRO-002-Asignar Revisor Proveedores
  COD_PRO_003 = 'PRO-003'
  COD_PRO_004 = 'PRO-004'
  COD_PRO_005 = 'PRO-005'
  COD_PRO_006 = 'PRO-006'
  COD_PRO_007 = 'PRO-007'
  COD_PRO_008 = 'PRO-008'
  COD_PRO_009 = 'PRO-009'
  COD_PRO_010 = 'PRO-010'

	COD_FPL_020 = 'FPL-020'
	COD_FPL_02 = 'FPL-02'
	COD_FPL_03 = 'FPL-03'
	COD_FPL_04 = 'FPL-04'
	COD_FPL_05 = 'FPL-05'
	COD_FPL_06 = 'FPL-06'
	COD_FPL_07 = 'FPL-07'
	COD_FPL_08 = 'FPL-08'
	COD_FPL_09 = 'FPL-09'
	COD_FPL_10 = 'FPL-10'

	#etapas de acuerdo
	ETAPA_ACUERDO_MANIFESTACION_INTERES = [ID_APL_001, ID_APL_002, ID_APL_003_1, ID_APL_003_2, ID_APL_004_1, ID_APL_004_2, ID_APL_005, ID_APL_006]
	ETAPA_ACUERDO_DIAGNOSTICO = [ID_APL_007, ID_APL_008, ID_APL_011, ID_APL_012, ID_APL_013, ID_APL_014]
	ETAPA_ACUERDO_PROPUESTA_ACUERDO = [ID_APL_016, ID_APL_017, ID_APL_018, ID_APL_019, ID_APL_020, ID_APL_021]
	ETAPA_ACUERDO_ADHESION = [ID_APL_022, ID_APL_023, ID_APL_024, ID_APL_025, ID_APL_025_1, ID_APL_025_2, ID_APL_025_3, ID_APL_026, ID_APL_027, ID_APL_028]
	ETAPA_ACUERDO_IMPLEMENTACION = [ID_APL_029, ID_APL_030, ID_APL_031, ID_APL_032, ID_APL_033, ID_APL_034]
	ETAPA_ACUERDO_EVALUACION_FINAL_CUMPLIMIENTO = [ID_APL_034, ID_APL_037, ID_APL_038, ID_APL_039, ID_APL_040, ID_APL_041, ID_APL_042, ID_APL_043, ID_APL_044]

end
