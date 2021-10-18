class Contribuyente < ApplicationRecord
	attr_accessor :filter_mode, :es_para_seleccion, :buscar_por_actividad_economica, :actividad_economica_id, :resultado_mostrados, :nombre_de_establecimiento, :tipo_de_establecimiento, :from_establecimientos, :custom_id, :data_table, :nombre_maquinaria, :numero_serie, :patente, :es_maquinaria, :seleccion_basica, :tipo_instrumento

	has_many :dato_anual_contribuyentes, foreign_key: :contribuyente_id, dependent: :destroy
	has_many :establecimiento_contribuyentes, foreign_key: :contribuyente_id, inverse_of: :contribuyente, dependent: :destroy
	has_many :actividad_economica_contribuyentes, foreign_key: :contribuyente_id, dependent: :destroy
	has_many :actividad_economicas, through: :actividad_economica_contribuyentes
	has_many :personas, dependent: :destroy
	has_many :maquinarias, dependent: :destroy
	has_many :otros, dependent: :destroy
  belongs_to :contribuyente, optional: true
  belongs_to :flujo, optional: true

	serialize :fields_visibility

	accepts_nested_attributes_for :actividad_economica_contribuyentes, :allow_destroy => true, reject_if: :all_blank
	accepts_nested_attributes_for :establecimiento_contribuyentes, :allow_destroy => true, reject_if: :all_blank
	accepts_nested_attributes_for :dato_anual_contribuyentes, :allow_destroy => true, reject_if: :all_blank

	validates :rut, presence: true, if: proc{!self.filter_mode}
	validates :dv, presence: true, if: proc{!self.filter_mode}
	validates :razon_social, presence: true, if: proc{!self.filter_mode}
	#validates_uniqueness_of :rut, if: proc{!self.filter_mode && self.contribuyente_id.nil?}

	validate :filter_data, if: proc{self.filter_mode==true && self.from_establecimientos==false}
	validate :rut_dv, if: proc{!self.filter_mode}

	#Se añade ya que se deben excluir las insituciones temporales
	validate :rut_unico, if: proc{!self.filter_mode && self.contribuyente_id.nil?}

	alias_attribute :nombre, :razon_social

	default_scope { where(temporal: false) }

	def rut_unico
		busqueda_identico = Contribuyente.where(rut: self.rut, temporal: false).first
		if !busqueda_identico.blank? && busqueda_identico.id != self.id
			errors.add(:rut, "Este RUT ya está siendo utilizado")
		end
	end

	def filter_data
		if (self.rut.blank? && self.razon_social.blank? && self.actividad_economica_id.blank? )
			errors.add(:rut, "Indique un RUT")
			#errors.add(:dv, "Indique el dígito verificador del RUT")
			errors.add(:razon_social, "Indique la razón social")
			errors.add(:actividad_economica_id, "Indique una actividad económica")
		#elsif (self.dv.blank? && ! self.rut.blank?)
		#	errors.add(:dv, "Indique el dígito verificador del RUT")
		#elsif (self.rut.blank?)
		#	errors.add(:rut, "Indique el RUT del dígito verificador")
		elsif (! self.razon_social.blank? && self.razon_social.size < 4)
			errors.add(:razon_social, "Indique escribir un nombre igual o mayor a 4 caracteres")
		end
	end

	def rut_dv
		if ( ! self.rut.blank? && ! self.dv.blank? )
			unless "#{self.rut}-#{self.dv}".rut_valid?
				errors.add(:rut, "Indique un RUT válido")
				errors.add(:dv, "El dígito verificador no corresponde al RUT ingresado")
			end
		end
	end

	def rut_completo
		"#{self.rut.blank? ? 'sin-rut' : self.rut}-#{self.dv.blank? ? 'sin-dígito-verificador' : self.dv}"
	end

	def direccion_casa_matriz(as_string=true,full=false)
		direccion_hash={ direccion: "Dirección no encontrada", comuna: nil, region: nil, pais: nil }
		ec=establecimiento_contribuyentes.where(casa_matriz: true).first
		if ec.blank?
			ec = establecimiento_contribuyentes.first
		end
		unless ec.blank?
			direccion_hash[:direccion] = "#{ec.direccion}"
			if full
				direccion_hash[:id] = ec.id
        direccion_hash[:comuna] = ec.comuna.nombre
				direccion_hash[:region] = ec.comuna.provincia.region.nombre
				direccion_hash[:pais] = ec.comuna.provincia.region.pais.nombre
			end
		end
		if as_string
			direccion_hash.inject(""){|s,(k,v)| s+= "#{v} " unless v.blank?; s}.strip
		else
			direccion_hash
		end
	end

	def direccion_principal
		casa_matriz = self.establecimiento_contribuyentes.where(casa_matriz: true).first
		if casa_matriz.present?
			direccion = casa_matriz
		else
			direccion = establecimiento_contribuyentes.first
		end
    direccion
	end

	def tipo_contribuyente
		tipo_string = "Tipo contribuyente no informado"
		tc = dato_anual_contribuyentes.where.not(tipo_contribuyente_id: nil).order(periodo: :desc).first
		unless tc.blank?
			tipo_string = tc.tipo_contribuyente.nombre
		end
		tipo_string
	end

	def tipo_contribuyente_id
		tipo_id = nil
		tc = dato_anual_contribuyentes.where.not(tipo_contribuyente_id: nil).order(periodo: :desc).first
		unless tc.blank?
			tipo_id = tc.tipo_contribuyente.id
		end
		tipo_id
	end

	#DZC
	def determina_establecimientos
		establecimientos = EstablecimientoContribuyente.where(contribuyente_id: self.id).all
	end

	# DZC 2018-11-13 11:27:19 se modifica para correcta aplicación de filtros de auditoría y elemento adherido
  def obtiene_procentaje_cumplimiento(flujo_id, auditoria_especifica=nil, elemento_especifico=nil)

  	
  	adhesiones = Adhesion.where(flujo_id: flujo_id)
  	personas = self.personas
  	# adhesion_elementos = AdhesionElemento.where(adhesion_id: adhesiones.pluck(:id), persona_id: personas.pluck(:id))
  	if auditoria_especifica.present?
  		auditorias = auditoria_especifica.is_a?(Auditoria) ? [auditoria_especifica]: auditoria_especifica
  	else
  		auditorias = Auditoria.where(flujo_id: flujo_id)
  	end
  	if elemento_especifico.present?
  		adhesion_elementos = elemento_especifico.is_a?(AdhesionElemento) ? [elemento_especifico] : elemento_especifico
  		# elemento_especifico = elemento_especifico.is_a?(AdhesionElemento) ? [elemento_especifico] : elemento_especifico
  		# adhesion_elementos = adhesion_elementos.select do |ae|
  		# 	elemento_especifico.pluck(:id).include?(ae[:id]) 
  	# 	end 
  	else
  		adhesion_elementos = AdhesionElemento.where(adhesion_id: adhesiones.pluck(:id), persona_id: personas.pluck(:id))
  	end
    

    
    # #DZC todas las acciones que tienen este elemento
    # adhesiones = Adhesion.where(flujo_id: flujo_id)
    # personas = self.personas
    # adhesion_elementos = elemento_especifico.blank? ? AdhesionElemento.where(adhesion_id: adhesiones.pluck(:id), persona_id: personas.pluck(:id)) : [elemento_especifico]
    # auditorias = auditoria_especifica.blank? ? Auditoria.where(flujo_id: flujo_id) : [auditoria_especifica]
    
    auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias.pluck(:id), adhesion_elemento_id: adhesion_elementos.pluck(:id))
		total_auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true).size.to_f
		total_auditorias_aplica = auditoria_elementos.where(aplica: true).size.to_f
		porcentaje = (total_auditorias_aplica > 0)? (total_auditorias_cumple_aplica/total_auditorias_aplica).to_f : 0.to_f
    porcentaje_cumplimiento =  "#{(porcentaje*100).round(2)}%"

    
    # flujo_id = self.adhesion.flujo.id
    # auditoria_elementos_del_elemento_adherido = AuditoriaElemento.where(adhesion_elemento_id: self.id)
    # auditorias = Auditoria.where(id: auditoria_elementos_del_elemento_adherido.pluck(:auditoria_id), flujo_id: flujo_id)
    # set_metas_acciones = SetMetasAccion.where(id: auditoria_elementos_del_elemento_adherido.pluck(:set_metas_accion_id), flujo_id: flujo_id)
    # auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias.pluck(:id), adhesion_elemento_id: self.id, set_metas_accion_id: set_metas_acciones.pluck(:id))
    # total_auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true).size.to_f
    # total_auditorias_aplica = auditoria_elementos.where(aplica: true).size.to_f
    # porcentaje = (total_auditorias_aplica > 0)? (total_auditorias_cumple_aplica/total_auditorias_aplica).to_f : 0.to_f
    # porcentaje_cumplimiento =  "#{porcentaje*100}%"
  end

  def ultimo_dato_anual
  	da = dato_anual_contribuyentes.where.not(periodo: nil).order(periodo: :desc)
  	da = dato_anual_contribuyentes.order(id: :desc) if da.size == 0
  	da.first
  end

  def clonar_con_relaciones
    copia_contribuyente = self.dup
    copia_contribuyente.contribuyente_id = self.id
    copia_contribuyente.save(validate: false)
    self.dato_anual_contribuyentes.each{|r| 
      rc = r.dup
      rc.contribuyente_id = copia_contribuyente.id
      rc.save
    }
    self.establecimiento_contribuyentes.each{|r| 
      rc = r.dup
      rc.establecimiento_contribuyente_id = r.id
      rc.contribuyente_id = copia_contribuyente.id
      rc.save
    }
    self.actividad_economica_contribuyentes.each{|r| 
      rc = r.dup
      rc.contribuyente_id = copia_contribuyente.id
      rc.save
    }
    copia_contribuyente
  end

  def confirmar_temporal
  	if(self.contribuyente_id.nil?)
  		#Es nuevo
  		contribuyente_final = self
  		contribuyente_final.temporal = false
  		contribuyente_final.flujo_id = nil
  		contribuyente_final.save
  	else
  		#Se edito uno existente
	  	contribuyente_final = Contribuyente.find(self.contribuyente_id)

	  	#Primero los valores del padre
	  	contribuyente_final.razon_social = self.razon_social
	  	contribuyente_final.save(validate: false)

	  	#Despues los hijos
	  	#actividades economicas se reemplaza completo
	  	contribuyente_final.actividad_economica_contribuyentes.destroy_all
	  	self.actividad_economica_contribuyentes.each{|r| 
	      rc = r.dup
	      rc.contribuyente_id = self.contribuyente_id
	      rc.save
	    }

	  	#establecimientos se reemplazan los datos de originales
	  	#primero elimino los que en temporal se eliminaron
	  	establecimientos_ids = self.establecimiento_contribuyentes.pluck(:establecimiento_contribuyente_id)
	  	contribuyente_final.establecimiento_contribuyentes.where(contribuyente_id: self.contribuyente_id).where.not(id: establecimientos_ids).destroy_all
	  	#despues actualizo los valoresde los originales
	  	self.establecimiento_contribuyentes.each do |ect|
	  		if ect.establecimiento_contribuyente_id.nil?
	  			#Si es nulo es porque es nuevo
	  			ect.contribuyente_id = self.contribuyente_id
	  			ect.save
	  		else
	  			#Si no es nulo se actualiza el original
	  			ec = EstablecimientoContribuyente.find(ect.establecimiento_contribuyente_id)
	  			ec.casa_matriz = ect.casa_matriz
	  			ec.direccion = ect.direccion
	  			ec.ciudad = ect.ciudad
	  			ec.pais_id = ect.pais_id
	  			ec.region_id = ect.region_id
	  			ec.comuna_id = ect.comuna_id
	  			ec.save
	  		end
	  	end
	  	contribuyente_final.reload
	  end

  	contribuyente_final
  end

  def elementos_certificados
    elementos_certificados = []
    # DZC 2018-11-14 14:57:42 obtenemos los elementos adheridos
    adhesion_elementos = AdhesionElemento.joins([:persona, :adhesion]).where(personas: {contribuyente_id: self.id})

    # DZC 2018-11-14 14:58:01 obtenemos las auditorias con certificacion y ceremonia
    auditorias = Auditoria.where(flujo_id: adhesion_elementos.pluck("adhesiones.flujo_id").uniq, con_certificacion: true)

    # DZC 2018-11-14 18:23:57 obtenemos los elementos de auditoria correspondientes a la auditoria y elementos adheridos
    auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias.pluck(:id), adhesion_elemento_id: adhesion_elementos.pluck(:id)).uniq

    # DZC 2018-11-14 18:18:28 obtenemos un array de elementos a revisar por la dupla auditoria y elemento adherido de la tabla auditoria_elementos
    elementos_por_revisar = auditoria_elementos.map do |aud_elem|
      {auditoria_id: aud_elem[:auditoria_id], adhesion_elemento_id: aud_elem[:adhesion_elemento_id]}
    end
    # DZC 2018-11-14 18:19:16 revisamos el cumplimiento de cada elemento adherido en funcion a la auditoría asociada y al set de metas y acciones respectivo
    elementos_por_revisar.uniq.each do |ear|
      
      auditoria = auditorias.select do |a|
        a[:id] == ear[:auditoria_id]
      end
      auditoria = auditoria.first
      adhesion_elemento = adhesion_elementos.select do |adh_elem|
        adh_elem[:id] == ear[:adhesion_elemento_id]
      end
      adhesion_elemento = adhesion_elemento.first

      cumplimiento = adhesion_elemento.calcula_porcentaje_cumplimiento(auditoria, true)
      if cumplimiento == 1
        rut_institucion = adhesion_elemento.fila[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first
        institucion = Contribuyente.find_by(rut: rut_institucion)
        # DZC 2018-11-14 18:21:24 obtenemos la fecha de certificación en función a la fecha del acta de la ceremonia
        convocatoria_id = auditoria.convocatoria_id
        minuta_ceremonia = convocatoria_id.present? ? Minuta.find_by(convocatoria_id: convocatoria_id) : nil
        if (minuta_ceremonia.present? && minuta_ceremonia.fecha_acta.present?)
          flujo = auditoria.flujo
          # DZC 2018-11-15 15:15:22 contemplamos el caso de que el plazo de certificación sea "con_e"
          #tiene_extension = (flujo.manifestacion_de_interes.present? && flujo.manifestacion_de_interes.informe_acuerdo.present? && flujo.manifestacion_de_interes.informe_acuerdo.con_extension)
          fecha_certificacion = minuta_ceremonia.fecha_acta.strftime("%F")
          #tiempo = tiene_extension ? 6 : 3
          #ToDo: definir cuando es con nivel y tomar plazo de nivel
          if auditoria.final
            #si es audit final tomo valor general de informe
            tiempo = auditoria.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final
          else
            #si no el plazo cargado en lista de plazos
            tiempo = auditoria.plazo
            #si no esta en la lista de plazos utilizo el de auditoria final
            tiempo = auditoria.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final if tiempo.blank?
          end
          tiempo_calculado = 0
          if tiempo.blank?
            #para version antigua (utilizaba meses)
            tiempo = auditoria.plazo if tiempo.blank?
            #si no existe dato se fuerza a el plazo minimo (1 año/12 meses)
            tiempo = 12 if tiempo.blank?
            tiempo_calculado = tiempo
          else
            #años a meses
            tiempo_calculado = tiempo * 12
          end
          vigencia_certificacion = (minuta_ceremonia.fecha_acta + tiempo_calculado.months).strftime("%F")
        else
          fecha_certificacion = "Pendiente"
          vigencia_certificacion = "Pendiente"
        end
        # DZC 2018-11-14 18:21:50 agregamos los datos correspondientes al elemento certificado
        elementos_certificados << {
          auditoria_id: auditoria.id,
          auditoria_nombre: auditoria.nombre,
          tipo_elemento: adhesion_elemento.alcance.nombre,
          id_elemento: adhesion_elemento.id,
          nombre_elemento: adhesion_elemento.nombre_segun_alcance,
          fecha_certificacion: fecha_certificacion,
          con_extension: "No",
          vigencia_certificacion: vigencia_certificacion, 
          nombre_acuerdo: adhesion_elemento.adhesion.flujo.nombre_instrumento,
          nombre_institucion: institucion.razon_social,
          rut_institucion: adhesion_elemento.fila[:rut_institucion],
          region: institucion.direccion_principal.comuna.provincia.region.nombre,
          comuna: institucion.direccion_principal.comuna.nombre
        }
      end
    end
    elementos_certificados
  end
end
