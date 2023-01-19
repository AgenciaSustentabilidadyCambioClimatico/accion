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
	# validate :rut_unico, if: proc{!self.filter_mode && self.contribuyente_id.nil?}

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

  	
  	adhesiones = Adhesion.unscoped.where(flujo_id: flujo_id)
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
	  	aec = contribuyente_final.actividad_economica_contribuyentes.destroy_all
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
		#v2
		elementos_certificados = []
    #obtengo elementos
    AdhesionElemento.all.each do |adhesion_elemento|
    	#filtro solo los que sean de mi empresa
    	if adhesion_elemento.fila[:rut_institucion].to_s.gsub("k","K").gsub(".","") == "#{self.rut}-#{self.dv}".to_s.gsub("k","K").gsub(".","")

        institucion = Contribuyente.find_by(rut: self.rut)

  			flujo = adhesion_elemento.adhesion.flujo
  			manif_de_interes = flujo.manifestacion_de_interes
  			auditorias = Auditoria.where(flujo_id: flujo.id).order(plazo_cierre: :desc)
    		niveles = {}

    		auditorias.each do |aud|

	    		fecha_certificacion = "Pendiente"
	    		vigencia_certificacion = "Pendiente"
	    		vigente = false

	    		#la fecha de ceremonia viende de la manif
	    		fecha_ceremonia = manif_de_interes.ceremonia_certificacion_fecha
	    		fecha_ceremonia = manif_de_interes.ceremonia_certificacion_fecha_hora if fecha_ceremonia.blank?


	    		#si auditoria tiene certificacion puedo agregarlo a tabla
	    		if aud.con_certificacion
	    			#si ya se hizo la ceremonia puedo certificar
	    			if !fecha_ceremonia.blank?
		    			auditoria_elementos = aud.auditoria_elementos.where(adhesion_elemento_id: adhesion_elemento.id)

		    			#si tiene elementos revisados y cumplo con el 100% entonces esta certificado 
		    			if auditoria_elementos.count > 0 && adhesion_elemento.calcula_porcentaje_cumplimiento(aud, true) == 1

		    				#fecha certificacion depende de la tarea, si es solo con cert lo tomo desde el ultimo elemento certificado
		    				_fecha_cert = auditoria_elementos.order(aprobacion_fecha: :asc).last.aprobacion_fecha
		    				if aud.con_validacion
		    					#si tiene validacion lo tomo desde dato de validacion
		    					_fecha_cert = (AuditoriaValidacion.find_by(auditoria_id: aud.id).updated_at rescue nil)
		    				end

		    				if !_fecha_cert.blank?
			    				if aud.final
				            #si es audit final tomo valor general de informe
				            tiempo = aud.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final
				          else
				            #si no el plazo cargado en lista de plazos
				            tiempo = aud.plazo
				            #si no esta en la lista de plazos utilizo el de auditoria final
				            tiempo = aud.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final if tiempo.blank?
				          end
				          tiempo_calculado = 0
				          if tiempo.blank?
				            #para version antigua (utilizaba meses)
				            tiempo = aud.plazo if tiempo.blank?
				            #si no existe dato se fuerza a el plazo minimo (1 año/12 meses)
				            tiempo = 12 if tiempo.blank?
				            tiempo_calculado = tiempo
				          else
				            #años a meses
				            tiempo_calculado = tiempo * 12
				          end

				          #la vigencia se calcula
				          _vigencia_certificacion = (_fecha_cert + tiempo_calculado.months)

				          fecha_certificacion = _fecha_cert.strftime("%F")
				          vigencia_certificacion = _vigencia_certificacion.strftime("%F")
				          vigente = _vigencia_certificacion >= Date.today

				          nivel = adhesion_elemento.cumple_nivel(aud)
					    		if !nivel.nil?
					          
					          #cargo el plazo del nivel
				            _tiempo = nivel.plazo
				            #si nivel no tiene cargo el de auditoria
				            _tiempo = aud.plazo if _tiempo.blank?
				            #si auditoria no tiene cargo el de aud final
				            _tiempo = aud.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final if _tiempo.blank?
				            #si no existe plazo final se fuerza al minimo 1 año/12 meses
				            _tiempo = 1 if _tiempo.blank?

					          _tiempo_calculado = _tiempo * 12

					          _vigencia_certificacion_nivel = (_fecha_cert + _tiempo_calculado.months)
					          vigencia_certificacion_nivel = _vigencia_certificacion_nivel.strftime("%F")
					          vigente_nivel = _vigencia_certificacion_nivel >= Date.today

					          if !niveles.has_key?(nivel.id)
					          	#evito que niveles se repitan
					    				niveles[nivel.id] = {aud_nivel: nivel, auditoria: aud, fecha_certificacion: fecha_certificacion, vigencia_certificacion: vigencia_certificacion_nivel, vigente: vigente_nivel}
					    			end
					    		end


				        end

				        
		    			end

		    		end

		    		#este es de validacion general
		    		elementos_certificados << {
		          auditoria_id: aud.id,
		          auditoria_nombre: aud.nombre,
		          tipo_elemento: adhesion_elemento.alcance.nombre,
		          id_elemento: adhesion_elemento.id,
		          nombre_elemento: adhesion_elemento.nombre_del_elemento_v2,
		          fecha_certificacion: fecha_certificacion,
		          con_extension: "No",
		          vigencia_certificacion: vigencia_certificacion, 
		          nombre_acuerdo: manif_de_interes.nombre_acuerdo,
		          nombre_estandar: nil,
		          nombre_institucion: institucion.razon_social,
		          rut_institucion: adhesion_elemento.fila[:rut_institucion],
		          region: institucion.direccion_principal.comuna.provincia.region.nombre,
		          comuna: institucion.direccion_principal.comuna.nombre,
		          vigente: vigente,
		          nivel_id: nil
		        }
	    		end

    		end

        #este es de validacion por nivel
        niveles.each do |nivel_id, data|
        	elementos_certificados << {
	          auditoria_id: data[:auditoria].id,
	          auditoria_nombre: data[:auditoria].nombre,
	          tipo_elemento: adhesion_elemento.alcance.nombre,
	          id_elemento: adhesion_elemento.id,
	          nombre_elemento: adhesion_elemento.nombre_del_elemento_v2,
	          fecha_certificacion: data[:fecha_certificacion],
	          con_extension: "No",
	          vigencia_certificacion: data[:vigencia_certificacion], 
	          nombre_acuerdo: adhesion_elemento.adhesion.flujo.nombre_instrumento,
	          nombre_estandar: data[:aud_nivel].estandar_nivel.estandar_homologacion.nombre+"-"+data[:aud_nivel].estandar_nivel.nombre, 
	          nombre_institucion: institucion.razon_social,
	          rut_institucion: adhesion_elemento.fila[:rut_institucion],
	          region: institucion.direccion_principal.comuna.provincia.region.nombre,
	          comuna: institucion.direccion_principal.comuna.nombre,
	          vigente: data[:vigente],
	          nivel_id: nivel_id
	        }
        end
    	end
    end

    elementos_certificados
  end
end
