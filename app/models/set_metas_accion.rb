class SetMetasAccion < ApplicationRecord
	attr_accessor :clasificacion_para_filtro
	belongs_to :accion
	belongs_to :materia_sustancia, optional: true
	belongs_to :meta, optional: true, foreign_key: :meta_id, class_name: :Clasificacion
	belongs_to :alcance, optional: true
	# has_one :manifestacion_de_interes
	belongs_to :flujo, optional: true
	#belongs_to :establecimiento_contribuyente, optional: true
	belongs_to :ppf_metas_establecimiento, optional: true
	# serialize :comentarios_y_observaciones_set_metas_acciones
	has_many :dato_productivo_elemento_adherido, dependent: :destroy
	has_many :auditoria_elementos, dependent: :destroy

	mount_uploader :archivo_acta_comite, ArchivoActaComiteSetMetasAccionUploader

	enum plazo_unidad_tiempo: [ :years, :months ]
	
	validates :accion_id, presence: true
	validates :meta_id, presence: true
	validates :valor_referencia, presence: true
	validates :alcance_id, presence: true , if: -> { ppf_metas_establecimiento_id.blank? }
	validates :criterio_inclusion_exclusion, presence: true
	validates :descripcion_accion, presence: true
	#validates :detalle_medio_verificacion, presence: true
	validates :plazo_valor, presence: true
	validates :plazo_unidad_tiempo, presence: true

	def self.de_la_manifestacion_de_interes_(id, anexo=false)
		anexo_array = []
		anexo_array = (anexo==false)? [anexo, nil] : [anexo]
		flujo_id=Flujo.find_by(manifestacion_de_interes_id: id).id
		SetMetasAccion
			.includes([:accion,:materia_sustancia,:meta,:alcance])
			.where(
				flujo_id: flujo_id
			)
			.where(
				anexo: anexo_array
			)
			.all
	end

	def es_editable(tarea_codigo)
		editable = 'no'
		editable = ([Tarea::COD_APL_013, Tarea::COD_APL_018].include?(tarea_codigo)) ? 'total' : editable # DZC 2018-11-02 19:08:00 se ellimina Tarea::COD_APL_020 del listado
		editable = ([Tarea::COD_APL_023].include?(tarea_codigo)) ? 'parcial' : editable
		editable
	end

	# DZC 2018-11-02 19:30:47 se agrega condición de borrado para set de metas y acciones
	def es_borrable?(tarea_codigo)
		borrable = true
		borrable = ([Tarea::COD_APL_019, Tarea::COD_APL_020, Tarea::COD_APL_023].include?(tarea_codigo)) && self.anexo == false ? false : borrable
		borrable = [Tarea::COD_APL_014].include?(tarea_codigo) ? false : borrable
		borrable
	end

	def self.by_flujo(flujo_id, establecimiento_id, anexo=false)
		SetMetasAccion.includes([:accion,:materia_sustancia,:meta,:alcance]).where(flujo_id: flujo_id).where(establecimiento_contribuyente_id: establecimiento_id).where(anexo: [anexo, nil]).all
	end

	# DZC 2018-11-13 11:39:28 se modifica para correcta aplicación de filtros de auditoría y elemento adherido
	def obtiene_procentaje_cumplimiento(auditoria_especifica=nil, elemento_especifico=nil)
		
		auditorias = auditoria_especifica.blank? ? Auditoria.where(flujo_id: self.flujo.id) : [auditoria_especifica]
		auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias.pluck(:id), set_metas_accion_id: self.id)
		
		auditoria_elementos = elemento_especifico.present? ? auditoria_elementos.where(adhesion_elemento_id: elemento_especifico.id) : auditoria_elementos
		if auditoria_elementos.present?
			total_auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true).size.to_f
			total_auditorias_aplica = auditoria_elementos.where(aplica: true).size.to_f
			porcentaje = (total_auditorias_aplica > 0)? (total_auditorias_cumple_aplica/total_auditorias_aplica).to_f : 0.to_f
			porcentaje_cumplimiento =  "#{(porcentaje*100).round(2)}%"
		else
			porcentaje_cumplimiento =  "Elemento adherido fuera de alcance"
		end
	end

	def estado_vista
		if self.estado == 3
			es = "<i class='fa fa-check text-success'></i> No"
		elsif self.estado == 2
			es = "<i class='fa fa-times text-danger'></i> Sí"
		elsif self.estado == 1
			es = "Pendiente"
		else
			es = "Conflicto"
		end
		es
	end

	def estado_gestionar_instrumentos
		if self.estado == 3
			es = "Aprobado"
		elsif self.estado == 2
			es = "Observado"
		elsif self.estado == 1
			es = "Pendiente"
		else
			es = "Conflicto"
		end
		es
	end

	def llave_origen
		if !self.id_referencia.blank?
			if self.modelo_referencia == "EstandarSetMetasAccion"
	      eh = EstandarSetMetasAccion.find(self.id_referencia).estandar_homologacion
	      return eh.id.to_s+"-EstandarHomologacion"
	    else
	      mi = SetMetasAccion.find(self.id_referencia).flujo.manifestacion_de_interes
	      return mi.id.to_s+"-ManifestacionDeInteres"
	    end
	  else
	  	return ""
	  end
	end

end
