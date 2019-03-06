class ProyectoActividad < ApplicationRecord
	belongs_to :proyecto
	has_many :actividad_item, -> {includes [:estado_tecnica,:estado_respaldo, :tipo_aporte] }, dependent: :destroy, :inverse_of => :proyecto_actividad

	validates :nombre, presence: true
	#validates :fecha_finalizacion, presence: true

	accepts_nested_attributes_for :actividad_item, :allow_destroy => true, reject_if: :all_blank

	attr_accessor :monto_items, :gb_id, :en_revision, :modificado, :nuevo, :create_external

	def initialize(attributes = {})
		super(attributes)
		filtrar_nested_attributes
	end

	def update(attributes)
		super(attributes)
		filtrar_nested_attributes
	end

	def filtrar_nested_attributes
		if create_external.blank?
	    if self.actividad_item.size == 0
	      item = self.actividad_item.build
	      item.glosa_id = 1
	    else
	    	ai_array = []
	    	self.actividad_item.each do |ai|
	    		ai_array << ai
	    	end
	    	self.actividad_item = ai_array
	    end
	  end
	end

	def self.get_actividades_calendario proyecto_id 

		sql = 	'WITH montos AS (SELECT proyecto_actividad_id, glosa_id, tipo_aporte_id, SUM(monto) as "monto" 
					FROM actividad_items 
					GROUP BY proyecto_actividad_id, glosa_id, tipo_aporte_id),

					suma AS (SELECT proyecto_actividad_id,tipo_aporte_id, SUM(monto) as "monto" 
					FROM actividad_items 
					GROUP BY proyecto_actividad_id,tipo_aporte_id ),

					total AS (SELECT proyecto_actividad_id, SUM(monto) as "monto" 
					FROM actividad_items 
					GROUP BY proyecto_actividad_id )

					SELECT pa.nombre, 
					COALESCE(rp.monto, 0) as "rrhh_propios", 
					COALESCE(re_l.monto, 0) as "rrhh_externos_liquido",
					COALESCE(re_f.monto, 0) as "rrhh_externos_fpl",
					COALESCE(go_v.monto, 0) as "gastos_operaciones_valor",
					COALESCE(go_l.monto, 0) as "gastos_operaciones_liquido",
					COALESCE(go_f.monto, 0) as "gastos_operaciones_fpl",
					COALESCE(ga_v.monto, 0) as "gastos_adm_valor",
					COALESCE(ga_l.monto, 0) as "gastos_adm_liquido",
					COALESCE(ga_f.monto, 0) as "gastos_adm_fpl",
					pa.fecha_finalizacion,
					COALESCE(suma_v.monto, 0) as "suma_valorado",
					COALESCE(suma_l.monto, 0) as "suma_liquido",
					COALESCE(suma_f.monto, 0) as "suma_fpl",
					COALESCE(total.monto, 0) as "total" 
					FROM proyecto_actividades pa 
					LEFT JOIN montos rp ON rp.proyecto_actividad_id = pa.id AND rp.glosa_id = 1 AND rp.tipo_aporte_id = 1
					LEFT JOIN montos re_l ON re_l.proyecto_actividad_id = pa.id AND re_l.glosa_id = 2 AND re_l.tipo_aporte_id = 2
					LEFT JOIN montos re_f ON re_f.proyecto_actividad_id = pa.id AND re_f.glosa_id = 2 AND re_f.tipo_aporte_id = 3
					LEFT JOIN montos go_v ON go_v.proyecto_actividad_id = pa.id AND go_v.glosa_id = 3 AND go_v.tipo_aporte_id = 1
					LEFT JOIN montos go_l ON go_l.proyecto_actividad_id = pa.id AND go_l.glosa_id = 3 AND go_l.tipo_aporte_id = 2
					LEFT JOIN montos go_f ON go_f.proyecto_actividad_id = pa.id AND go_f.glosa_id = 3 AND go_f.tipo_aporte_id = 3
					LEFT JOIN montos ga_v ON ga_v.proyecto_actividad_id = pa.id AND ga_v.glosa_id = 4 AND ga_v.tipo_aporte_id = 1
					LEFT JOIN montos ga_l ON ga_l.proyecto_actividad_id = pa.id AND ga_l.glosa_id = 4 AND ga_l.tipo_aporte_id = 2
					LEFT JOIN montos ga_f ON ga_f.proyecto_actividad_id = pa.id AND ga_f.glosa_id = 4 AND ga_f.tipo_aporte_id = 3
					LEFT JOIN suma suma_v ON suma_v.proyecto_actividad_id = pa.id AND suma_v.tipo_aporte_id = 1
					LEFT JOIN suma suma_l ON suma_l.proyecto_actividad_id = pa.id AND suma_l.tipo_aporte_id = 2
					LEFT JOIN suma suma_f ON suma_f.proyecto_actividad_id = pa.id AND suma_f.tipo_aporte_id = 3
					LEFT JOIN total ON total.proyecto_actividad_id = pa.id
					WHERE pa.proyecto_id = '+proyecto_id.to_s+' ORDER BY pa.id'

		self.connection.exec_query(sql).to_hash
	end

	def glosas
		glosas_id = self.actividad_item.distinct.pluck("glosa_id")
		#Glosa.where(id: glosas_id).all
	end

	def actividad_items_length
		self.actividad_item.length+(4-self.glosas.length)
	end

	def monto_items_actividad
		monto = 0
		self.actividad_item.map { |e|  monto += e.monto.to_i}
		monto
	end

	def monto_items_actividad_lista
		monto = 0
		self.actividad_item.where(estado_tecnica_id: EstadoRendicion::ACEPTADA).where(estado_respaldo_id: EstadoRendicion::ACEPTADA).map { |e|  monto += e.monto.to_i}
		monto
	end

	def verificar_estado_items
		items = self.actividad_item
		aprobados = 0
		tecnica = 0
		contable = 0
		
		items.each do |i|
      etid=i.estado_tecnica_id
      erid=i.estado_respaldo_id

      if etid == EstadoRendicion::ACEPTADA && erid == EstadoRendicion::ACEPTADA
        aprobados += 1
      end

      if etid == EstadoRendicion::EN_REVISION || etid == EstadoRendicion::ACEPTADA
        tecnica += 1
      end

      if erid == EstadoRendicion::EN_REVISION || erid == EstadoRendicion::ACEPTADA
        contable += 1
      end
		end

		bloqueado = true

    if items.size == aprobados
      estado = "Aprobado"
    elsif contable > 0
      estado = "En revisión contable"
    elsif tecnica > 0
      estado = "En revisión técnica"
    else
    	bloqueado = false
    	estado = "Entrega pendiente"
    end
    {
    	estado: estado,
    	bloqueado: bloqueado,
    	aprobados: aprobados,
    	en_revision:{
    		tecnica: tecnica,
    		contable: contable
    	}
    }
	end

	def esta_proceso_o_aceptado?
		verificar_estado_items[:bloqueado]
	end

	def suma_total_fpl
		self.actividad_item.inject(0){ |s,e| s+= e.monto.to_i if ( e.tipo_aporte_id==TipoAporte::SOLICITADO_AL_FONDO ); s }
	end

	def monto_items_rendidos_y_en_proceso_rendicion
		monto = 0
		self.actividad_item.where.not(estado_tecnica_id: EstadoRendicion::NO_ENVIADA).map { |e|  monto += e.monto.to_i}
		monto
	end

end
