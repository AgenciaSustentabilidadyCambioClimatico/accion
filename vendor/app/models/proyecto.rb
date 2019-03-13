class Proyecto < ApplicationRecord
	serialize :comentario_modificacion
	mount_uploader :archivo_minuta_reunion, ArchivosProyectoUploader
	mount_uploader :archivo_resolucion, ArchivosProyectoUploader
	mount_uploader :archivo_contrato, ArchivosProyectoUploader

	belongs_to :contribuyente
	belongs_to :tipo_instrumento, foreign_key: 'tipo_instrumento_id', optional: true
	belongs_to :centro_de_costo, foreign_key: 'centro_costos_id', optional: true
	has_one :flujo
	has_many :documento_garantias
	has_many :proyecto_responsables
	has_many :proyecto_actividad, -> {includes :actividad_item }, dependent: :destroy 
	has_many :proyecto_pagos#, foreign_key: :proyecto_id, dependent: :destroy 
	has_many :reuniones
	has_many :rendiciones, -> { includes :modalidad }, foreign_key: :proyecto_id

	#RDO
	serialize :sectores_economicos
	serialize :territorios_regiones
	serialize :territorios_provincias
	serialize :territorios_comunas
	serialize :instrumentos_relacionados_historico

	accepts_nested_attributes_for :rendiciones, :allow_destroy => true#, reject_if: :all_blank
	accepts_nested_attributes_for :proyecto_actividad, :allow_destroy => true#, reject_if: :all_blank

	attr_accessor :funcion_a_probar, :esta_agregando_nuevo_anticipo, :comentario, :debe_agregar_comentario

	# validaciones segun lo que se desea realizar, en base a lo pasado en funcion_a_probar
	validates :fecha_restitucion, presence: true, if: proc{ self.funcion_a_probar == :restitucion }
	validates :monto_restitucion, presence: true, if: proc{ self.funcion_a_probar == :restitucion }

	# validates :archivo_resolucion, presence: true, if: proc{ self.funcion_a_probar == :resolucion_contrato }
	# validates :archivo_contrato, presence: true, if: proc{ self.funcion_a_probar == :resolucion_contrato }
	
	validates :fecha_pago_efectiva, presence: true, if: proc{ self.funcion_a_probar == :fecha_pago_efectiva }

	validates :revisor_tecnico_id, presence: true, if: proc{ self.funcion_a_probar == :responsables }
	validates :coordinador_id, presence: true, if: proc{ self.funcion_a_probar == :responsables }
	validates :centro_costos_id, presence: true, if: proc{ self.funcion_a_probar == :responsables }
	validates :fecha_inicio_contrato, presence: true, if: proc{ self.funcion_a_probar == :responsables }
	validates :fecha_fin_contrato, presence: true, if: proc{ self.funcion_a_probar == :responsables || self.funcion_a_probar == :resolucion_contrato }
	
	validates :archivo_resolucion, presence: true, if: proc{ self.funcion_a_probar == :responsables || self.funcion_a_probar == :resolucion_contrato }
	validates :archivo_contrato, presence: true, if: proc{ self.funcion_a_probar == :responsables || self.funcion_a_probar == :resolucion_contrato }
	validates :total_nuevo_anticipo, presence: true, numericality: { greater_than: 0 }, if: -> { esta_agregando_nuevo_anticipo == true }
	validates :comentario, presence: true, if: -> { debe_agregar_comentario == true }
	validate :minimo_maximo_nuevo_anticipo, if: -> { esta_agregando_nuevo_anticipo == true }

	validate :fecha_fin_contrato_mayor_a_fecha_finalizacion_actividad, if: -> { self.fecha_fin_contrato.present? && self.funcion_a_probar == :resolucion_contrato }

  #  validación condicionada para efectuar cambios de estado oculto
	validate :validar_fechas_contrato, if: proc{ (self.fecha_inicio_contrato.blank? === false && self.fecha_fin_contrato.blank? === false) }

	#Este scope esta pensado para diferenciar entre historico y no
	#default_scope { where("active = ?", true) }

	def total_garantizado_no_vencido
		__total_garantizado = 0
		self.documento_garantias.each do |dg|
			if dg.fecha_vencimiento >= Date.today #no vencido
				__total_garantizado+=dg.monto.to_i
			end
		end
		__total_garantizado
	end

	def iniciar_seguimiento!
		iniciado = false
		mensaje = nil
		tarea_fpl_003 = Tarea.find_by(codigo: Tarea::COD_FPL_003)
		usuarios_tarea_fpl_003 = tarea_fpl_003.responsables


		flujo = Flujo.new({
			contribuyente_id: self.contribuyente_id,
			tipo_instrumento_id: self.tipo_instrumento_id,
			proyecto_id: self.id,
		})

		if flujo.save

			flujo_tareas = FlujoTarea.where(tarea_entrada_id: Tarea::ID_FPL_002).all
			flujo_tareas.each do |ft|
				ft.continuar_flujo flujo.id
			end

			self.oculto = false
			self.iniciado = true
			self.fecha_iniciacion = Date.today
			iniciado = true

			self.proyecto_actividad.each do |actividad|
				actividad.update({fecha_finalizacion: self.fecha_iniciacion + actividad.duracion.months})
			end
		else
			ap flujo.errors.messages
			mensaje = "Hubo un error al iniciar el seguimiento"	
		end
		{
			iniciado: iniciado,
			mensaje: mensaje,
		}
	end

	def validar_fechas_contrato
		if self.fecha_inicio_contrato > self.fecha_fin_contrato
			errors.add(:fecha_fin_contrato, I18n.t('fecha_fin_debe_ser_mayor_a_inicio'))
		end
	end

	def ultima_fecha_finalizacion_actividades
		fecha = nil
		unless self.proyecto_actividad.blank?
			fecha = self.proyecto_actividad.order(fecha_finalizacion: :desc).first.fecha_finalizacion
		end
	end

	def monto_garantizado
		self.documento_garantias.where("fecha_vencimiento >= ?", Date.today)
				.where(estado_documento_garantia_id: [nil, EstadoDocumentoGarantia::DEVUELTO, EstadoDocumentoGarantia::COBRADO])
				.sum(:monto).to_i
	end

	def cc_ano_vigente
		monto_hasta_hoy = self.proyecto_pagos.where("fecha_pago <= ?", Time.now).sum(:monto) #pagos_hasta_hoy
		monto_disponible_año_vigente = self.centro_de_costo.blank? ? 0 : ( self.centro_de_costo.monto_asignacion - monto_hasta_hoy )
		# 10000000-self.monto_garantizado
	end

	def cc_con_compromisos
		montos_hasta_fin_año = self.proyecto_pagos.where("fecha_pago <= ?", Time.now.end_of_year).sum(:monto) #pagos_hasta_fin_año
		monto_disponible_menos_compromiso = self.centro_de_costo.blank? ? 0 : ( self.centro_de_costo.monto_asignacion - montos_hasta_fin_año )
		# 10000000-self.documento_garantias.sum(:monto)
	end
	def monto_asignado_fpl
		monto = 0
		self.proyecto_actividad.each do |pa|
			pa.actividad_item.each do |ai|
				monto += ai.monto
			end
		end
		monto
	end
	# def monto_rendido_fpl
	# 	monto = 0
	# 	self.proyecto_actividad.each do |pa|
	# 		pa.actividad_item.where("fecha_ultima_rendicion IS NOT NULL").each do |ai|
	# 			monto += ai.monto.to_i
	# 		end
	# 	end
	# 	monto
	# end
	def monto_rendido_fpl
		monto = 0
		self.proyecto_actividad.map{|pa| monto += pa.monto_items_actividad_lista }
		monto
	end
	def monto_pagado
		self.proyecto_pagos.map{|p| p.monto}.sum
	end
	def multas
		monto = 0
		self.rendiciones.each do |rend| 
      monto += rend.monto_multa
    end
    monto
	end

	def actividades_listas
		finalizado = true
		self.proyecto_actividad.each do |pa|
			pa.actividad_item.each do |ai|
				if ai.estado_tecnica_id != 3 || ai.estado_respaldo_id != 3
					finalizado = false
					break
				end
			end
			break if !finalizado
		end
		finalizado
	end

	def calendario_success tarea_pendiente, falta_rendir

		unless falta_rendir
			__total_anticipo = 0;
			__total_reembolso = 0;
			self.rendiciones.each do |r|
				if r.modalidad_id == Modalidad::ANTICIPO
					__total_anticipo+=r.suma_fpl.to_i
				elsif r.modalidad_id == Modalidad::REEMBOLSO
					__total_reembolso+=r.suma_fpl.to_i
				end
			end
			if (__total_anticipo>0 || __total_reembolso>0)
				self.total_anticipo = __total_anticipo
				self.total_reembolso = __total_reembolso
				self.save
			end
			tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
			if tarea_pendiente.save

				TareaPendiente.where(flujo_id: tarea_pendiente.flujo_id)
											.where(tarea_id: Tarea::ID_FPL_006)
											.update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)

				# Creamos un registro de este proyecto para mantener los cambios en la tarea 15
				ModificacionCalendario.agregar_proyecto_vacio(self.id)		
			end
		end

		flujo_tareas = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).all
		flujo_tareas.each do |ft|
			ft.continuar_flujo self.flujo.id
		end


	end

	def responsables_success params, tarea_pendiente

		tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
		if tarea_pendiente.save

			TareaPendiente.where(flujo_id: tarea_pendiente.flujo_id)
										.where(tarea_id: tarea_pendiente.tarea_id)
										.update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)


			MapaDeActor.find_or_create_by({
				flujo_id: self.flujo.id, 
				rol_id: Rol::COORDINADOR, 
				persona_id: params[:coordinador_id]
			})
			MapaDeActor.find_or_create_by({
				flujo_id: self.flujo.id, 
				rol_id: Rol::REVISOR_TECNICO, 
				persona_id: params[:revisor_tecnico_id]
			})
			MapaDeActor.find_or_create_by({
				flujo_id: self.flujo.id, 
				rol_id: Rol::RESPONSABLE_ENTREGABLES, 
				persona_id: params[:cogestor_id]
			})

			flujo_tarea = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id, condicion_de_salida: 'A').first
			flujo_tarea.continuar_flujo self.flujo.id
		end

	end

	def resolucion_restitucion_success tarea_pendiente

		tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
		if tarea_pendiente.save
			flujo_tareas = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).all
			flujo_tareas.each do |ft|
				ft.continuar_flujo self.flujo.id
			end
		end

	end

	def pago_success tarea_pendiente, pago_id
		flujo_tareas = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).where(condicion_de_salida: ['A', 'B']).all
		flujo_tareas.each do |ft|
			ft.continuar_flujo self.flujo.id, {pago_id: pago_id}
		end

	end

	def __dummy_gen_actividades(numero=5,unidad_tiempo=:weeks)
		nombre_actividades = [
			"Diseño Plan de Auditoria",
			"Taller de Difusión de los criterios de Auditoria",
			"Auditoria Final por Instalación (cargo de fondo)",
			"Auditoria Final por Instalación (cargo de beneficiario)",
			"Auditoria Final por Instalación (apoyo técnico)",
			"Elaboración de Informe Consolidado Final",
			"Coordinación y Realización del Informe de Evaluación de Impacto",
			"Coordinación y Realización del Informe de Evaluación de Impacto (apoyo técnico)",
			"Taller de Validación y Difusión de Resultados"
		]
		items = [
			{"nombre"=>"Jorge Mauricio Quintanilla Maldonado", "glosa_id"=>1, "tipo_aporte_id"=>1, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>360000},
			{"nombre"=>"Ricardo Antonio Quiroz Guajardo", "glosa_id"=>1, "tipo_aporte_id"=>1, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>"", "observacion_respaldo"=>"", "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>1025000},
			{"nombre"=>"Miguel Alfonso Duarte Contreras", "glosa_id"=>1, "tipo_aporte_id"=>1, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>"", "observacion_respaldo"=>"", "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>924000},
			{"nombre"=>"Osvaldo Alejandro Salazar Guerrero", "glosa_id"=>2, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>414000},
			{"nombre"=>"Carla Cecilia Soto Olguín", "glosa_id"=>2, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>828000},
			{"nombre"=>"Claudia Javiera Rojas Pinochet", "glosa_id"=>2, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>828000},
			{"nombre"=>"Martin Pérez Valdés", "glosa_id"=>2, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>208000},
			{"nombre"=>"Transporte", "glosa_id"=>3, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>390000},
			{"nombre"=>"Impresiones y Material de Difusión", "glosa_id"=>3, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>50000},
			{"nombre"=>"Material de Oficina", "glosa_id"=>4, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>100000},
			{"nombre"=>"Sala de Reunión", "glosa_id"=>4, "tipo_aporte_id"=>1, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>240000},
			{"nombre"=>"Arriendo de Equipos", "glosa_id"=>3, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>80000},
			{"nombre"=>"Arriendo de Salón", "glosa_id"=>3, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>100000},
			{"nombre"=>"Café", "glosa_id"=>3, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>378000},
			{"nombre"=>"Carlos Durán Cáceres", "glosa_id"=>2, "tipo_aporte_id"=>3, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>15300000},
			{"nombre"=>"Patricio Venegas Gamboa", "glosa_id"=>2, "tipo_aporte_id"=>2, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>1534000},
			{"nombre"=>"Transporte Técnico", "glosa_id"=>3, "tipo_aporte_id"=>1, "estado_tecnica_id"=>1, "estado_respaldo_id"=>1, "observacion_tecnica"=>nil, "observacion_respaldo"=>nil, "archivos_tecnica"=>nil, "archivos_respaldo"=>nil, "monto"=>715000}
		] 

		valor_tiempo = 1
		actividades = []
		nombre_actividades.sample(numero).each do |nombre|
			actividades << {
				nombre: nombre,
				fecha_finalizacion: self.fecha_iniciacion + valor_tiempo.send(unidad_tiempo),
				actividad_item_attributes: items.sample(numero)
			}
			valor_tiempo += 1
		end
		self.proyecto_actividad.create(actividades)
	end

	def calcular_total_cofinanciamiento(actualizar_campo=false)
		__total_cofinanciamiento = 0
		self.proyecto_actividad.each do |pa|
			__total_cofinanciamiento += pa.monto_items_rendidos_y_en_proceso_rendicion
		end
		self.total_cofinanciamiento = __total_cofinanciamiento
		if actualizar_campo
			self.save
		end
		__total_cofinanciamiento
	end

	def calcular_total_cofinanciamiento_rendido_mas_total_en_proceso_de_rendicion
		__total_cofinanciamiento = 0
		self.proyecto_actividad.each do |pa|
			__total_cofinanciamiento += pa.monto_items_rendidos_y_en_proceso_rendicion
		end
		__total_cofinanciamiento
	end

	def calcular_total_transferido
		self.proyecto_pagos.sum(:monto).to_i
	end

	def minimo_nuevo_anticipo
		self.total_garantizado_no_vencido + self.calcular_total_cofinanciamiento_rendido_mas_total_en_proceso_de_rendicion
	end

	def maximo_nuevo_anticipo
		( self.calcular_total_cofinanciamiento - self.calcular_total_cofinanciamiento_rendido_mas_total_en_proceso_de_rendicion ) + self.total_anticipo
	end

	def minimo_maximo_nuevo_anticipo
		__minimo_nuevo_anticipo = self.minimo_nuevo_anticipo
		__maximo_nuevo_anticipo = self.maximo_nuevo_anticipo
		if self.total_nuevo_anticipo < __minimo_nuevo_anticipo
			errors.add(:total_nuevo_anticipo, I18n.t(:valor_es_inferior_al_mínimo_permitido_,v:get_currency_format_of(__minimo_nuevo_anticipo)))
		elsif self.total_nuevo_anticipo > __maximo_nuevo_anticipo
			errors.add(:total_nuevo_anticipo, I18n.t(:valor_es_superior_al_máximo_permitido_,v:get_currency_format_of(__maximo_nuevo_anticipo)))
		end
	end

	def fecha_fin_contrato_mayor_a_fecha_finalizacion_actividad
		ultima_actividad = self.proyecto_actividad.all.sort_by{|pa|pa.fecha_finalizacion}.last
		unless self.fecha_fin_contrato.blank? || ultima_actividad.blank?
			if self.fecha_fin_contrato < ultima_actividad.fecha_finalizacion
				errors.add(:fecha_fin_contrato, I18n.t(:finalización_de_contrato_debe_ser_mayor_a_finalización_actividad, fecha: I18n.l(ultima_actividad.fecha_finalizacion,format: '%d-%m-%Y')))
			end
		end
	end

	def monto_proceso_pago
		self.proyecto_pagos.where(numero_orden_pago: nil).where(fecha_pago_efectiva: nil).sum(:monto).to_i
	end

	def en_proceso_pago?
		self.monto_proceso_pago > 0
	end

	def rendiciones_rendidas
		fecha_inicio = self.fecha_iniciacion
		self.rendiciones.order(fecha_rendicion: :asc).each do |r|
			self.proyecto_actividades
			.where("fecha_finalizacion > ? AND fecha_finalizacion <= ? ", fecha_inicio, r.fecha_rendicion)
			.order(fecha_finalizacion: :asc).each do |pa|
				return false if pa.verificar_estado_items[:estado] != "Aprobado"
			end
		end
		true
	end

end