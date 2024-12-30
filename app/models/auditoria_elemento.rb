class AuditoriaElemento < ApplicationRecord

	belongs_to :auditoria
	belongs_to :adhesion_elemento, optional: true
	belongs_to :set_metas_accion, optional: true
	#belongs_to :archivo_informe, class_name: "AuditoriaElementoArchivo" 
	#belongs_to :archivo_evidencia, class_name: "AuditoriaElementoArchivo" 

	mount_uploader :archivo_informe, ArchivoInformeEvidenciaAuditoriasUploader
	mount_uploader :archivo_evidencia, ArchivoInformeEvidenciaAuditoriasUploader
	#validates :archivo_informe, presence: true, on: :update
	#validates :archivo_evidencia, presence: true, on: :update

	attr_accessor :archivo_auditorias, :archivos_informe, :archivos_evidencia, :archivo_carga_auditoria

	validate :valid_extensions, if: -> { archivo_carga_auditoria.present? }
	#validate :data_auditoria, if: -> { archivo_carga_auditoria.present? }
	#validate :archivo_vacio, on: :update #, unless: -> { action_name == "revisar_guardar"}

	after_validation :aceptada_or_rechazada

	def estado_detalle
		estado_palabra = 'No encontrado'
		if self.estado == 1 #Pendiente, tiene este estado cuando se crea el registro por 1 vez y tiene campos vacios
			estado_palabra = 'Pendiente' #DZC se descarga en APL-032

		elsif self.estado == 2 #Revisión, posee este estado cuando se llenan los datos, o se modifica una con Observación- estos se bloquean para se editada nuevamente.-
			estado_palabra = 'En revisión'

		elsif self.estado == 3 #Observacion, cuando el revisor, le agrega observaciones
			estado_palabra = 'Con observaciones' #DZC se descarga en APL-032

		elsif self.estado == 4 # Rechazado, Cuando se da por descontinuado
			estado_palabra = 'Rechazado'

		elsif self.estado == 5 # Aprobado, cuando esta lista.
			estado_palabra = 'Aprobado'
		end      
	end

  def archivo_vacio
    if archivo_evidencia.file.nil? && archivo_informe.file.nil?
      errors.add(:archivo_invalido, "Archivo no encontrado")
    end
  end

  def updating_record?
    persisted? # This checks if the record already exists (i.e., it's an update)
  end

	def valid_extensions
		ext_audit = ["xlsx","xls"]
		ext_extra = ["zip", "rar", "pdf", "jpg", "jpeg", "png"]
		ext_arch_audit = self.archivo_auditorias.original_filename.split(".").last
		unless ext_audit.include?(ext_arch_audit)
			self.errors.add(:archivo_auditorias, I18n.t('errors.messages.extension_whitelist_error', extension: ext_arch_audit, allowed_types: ext_audit))
		end
		self.archivos_informe_y_evidencias.each do |arch|
			ext_arch_extra = arch.original_filename.split(".").last
			unless ext_extra.include?(ext_arch_extra)
				self.errors.add(:archivos_informe_y_evidencias, I18n.t('errors.messages.extension_whitelist_error', extension: ext_arch_audit, allowed_types: ext_extra))
			end
		end
	end

	def self.columnas_excel
		{
			rut_institucion: nil, #0
			nombre_institucion: nil, #1
			alcance: nil, #2
			# id_auditoria: nil, #3
			auditoria_elemento_id: nil, #3      
			nombre_elemento: nil, #4
			tipo_elemento: nil, #5
			fecha_adhesion: nil, #6
			direccion_instalacion: nil, #7
			comuna_instalacion: nil, #8
			nombre_encargado: nil, #9
			cargo_encargado: nil, #10
			fono_encargado: nil, #11
			email_encargado: nil, #12
			#id_accion: nil, #13
			descripcion_accion: nil, #14
			descripcion_verificador_accion: nil, #15
			plazo: nil, #16
			valor_referencia: nil, #17
			criterio_exclusion_inclusion: nil, #18
			aplica: "si_no", #19
			motivo: nil, #20
			cumple: "si_no", #21
			nombre_archivo_informe: nil, #22
			nombre_archivo_evidencia: nil, #23
			fecha_auditoria: nil, #24
			rut_auditor: nil #25
		} 
	end

	def self.parsear_auditorias archivo
		
		header = AuditoriaElemento.columnas_excel.map{|k,v| k}
		ExcelParser.new(archivo,header).tabulated
	end

	# Valida linea por linea los campos del archivo
	def self.data_auditoria(auditoria, tarea_codigo=nil)
		data = AuditoriaElemento.parsear_auditorias(auditoria.archivo_carga_auditoria)
		archivo_correcto = true
		if data.size <= 0
			auditoria.errors.add(:archivo_auditorias, "Debe indicar al menos una auditoria")
		else
			errores=AuditoriaElemento.columnas_excel.transform_values{|v| []}
			instituciones_con_archivo = []
			instituciones_con_fecha = []
			instituciones_con_rut = []

			data.each_with_index do |fila, posicion|
				
				# if fila[:aplica].blank? || fila[:cumple].blank? || fila[:id_auditoria].blank? || 
				#   fila[:nombre_archivo_informe].blank? || fila[:nombre_archivo_evidencia].blank? || 
				#   fila[:fecha_auditoria].blank? || fila[:rut_auditor].blank?
				#   auditoria.errors.add(:archivo_auditorias, "El archivo contiene celdas base sin completar")
				# else

				#   auditoria_elemento = AuditoriaElemento.find(fila[:id_auditoria])
				#DZC se cambia id_auditoria por auditoria_elemento_id 

				if fila[:aplica].blank? || fila[:cumple].blank? || fila[:auditoria_elemento_id].blank? || fila[:nombre_archivo_informe].blank? || fila[:nombre_archivo_evidencia].blank? || fila[:fecha_auditoria].blank? || fila[:rut_auditor].blank?
					if fila[:aplica].blank? 
						auditoria.errors.add(:archivo_auditorias, "El archivo contiene el campo aplica en blanco para fila #{(posicion+1)}")
					end
					if fila[:cumple].blank? 
						auditoria.errors.add(:archivo_auditorias, "El archivo contiene el campo cumple en blanco para fila #{(posicion+1)}")
					end
					if fila[:auditoria_elemento_id].blank? 
						auditoria.errors.add(:archivo_auditorias, "El archivo contiene el campo auditoria elemento en blanco para fila #{(posicion+1)}")
					end
					if fila[:nombre_archivo_informe].blank? 
						auditoria.errors.add(:archivo_auditorias, "El archivo contiene el campo archivo informe en blanco para fila #{(posicion+1)}")
					end
					if fila[:nombre_archivo_evidencia].blank? 
						auditoria.errors.add(:archivo_auditorias, "El archivo contiene el campo archivo evidencia en blanco para fila #{(posicion+1)}")
					end
					if fila[:fecha_auditoria].blank?
						auditoria.errors.add(:archivo_auditorias, "El archivo contiene el campo fecha auditoria en blanco para fila #{(posicion+1)}")
					end
					if fila[:rut_auditor].blank?
						auditoria.errors.add(:archivo_auditorias, "El archivo contiene el campo rut auditor en blanco para fila #{(posicion+1)}")
					end
				else

					auditoria_elemento = AuditoriaElemento.find_by(id: fila[:auditoria_elemento_id])
					if auditoria_elemento.nil? || auditoria_elemento.auditoria_id != auditoria.id
						auditoria.errors.add(:archivo_auditorias, "El elemento #{fila[:auditoria_elemento_id]} no pertenece a esta auditoría para fila #{(posicion+1)}")
					else
						if fila[:aplica].to_s == "NO" && fila[:motivo].blank?
							auditoria.errors.add(:archivo_auditorias, "Debe completar la celda Motivo para fila #{(posicion+1)}")
						end
						nombres_archivos_informe = auditoria.archivos_informe.map{|f| f.original_filename}
						unless nombres_archivos_informe.include?(fila[:nombre_archivo_informe])
							unless auditoria_elemento.archivo_informe_identifier == fila[:nombre_archivo_informe]
								auditoria.errors.add(:archivo_auditorias, "El Archivo informe #{fila[:nombre_archivo_informe]} no fue encontrado para fila #{(posicion+1)}")
							end
						end
						nombres_archivos_evidencia = auditoria.archivos_evidencia.map{|f| f.original_filename}
						unless nombres_archivos_evidencia.include?(fila[:nombre_archivo_evidencia])
							unless auditoria_elemento.archivo_evidencia_identifier == fila[:nombre_archivo_evidencia]
								auditoria.errors.add(:archivo_auditorias, "El Archivo evidencia #{fila[:nombre_archivo_evidencia]} no fue encontrado para fila #{(posicion+1)}")
							end
						end
						ext_extra = ["zip", "rar", "pdf", "jpg", "jpeg", "png"]
						extension = fila[:nombre_archivo_informe].split(".").last
						unless ext_extra.include?(extension)
							auditoria.errors.add(:archivo_auditorias, "El Archivo informe #{fila[:nombre_archivo_informe]} posee un tipo no válido, para la posición #{(posicion+1)}")
						end
						extension = fila[:nombre_archivo_evidencia].split(".").last
						unless ext_extra.include?(extension)
							auditoria.errors.add(:archivo_auditorias, "El Archivo evidencia #{fila[:nombre_archivo_evidencia]} posee un tipo no válido, para la posición #{(posicion+1)}")
						end

						unless fila[:fecha_auditoria].to_s.date_valid?
							errores[:fecha_auditoria] << fila[:fecha_auditoria]
						else
							_fecha_adh = fila[:fecha_adhesion]
							_fecha_adh = auditoria_elemento.adhesion_elemento.fila[:fecha_adhesion] if _fecha_adh.blank?
							fecha_adhesion = _fecha_adh.to_date
							if fecha_adhesion > Date.parse(fila[:fecha_auditoria])
								fecha_format = fecha_adhesion.strftime("%F")
								auditoria.errors.add(:archivo_auditorias, "La Fecha auditoria (#{fila[:fecha_auditoria]}) es menor a la fecha de adhesion (#{fecha_format}) para fila #{(posicion+1)}")
							end
						end
					end

					unless fila[:rut_auditor].to_s.rut_valid?
						errores[:rut_auditor] << fila[:rut_auditor]
					end
				end
			end

			errores.each do |k,v|
				if v.size > 0
					auditoria.errors.add(:archivo_auditorias, "El archivo contiene #{k.to_s.humanize} inválid@(s): #{v.join(',')}")
				end
			end
			
			if auditoria.errors.size == 0

				archivos_informe = {}
				auditoria.archivos_informe.each do |f|
					#creo archivo
					archivo = AuditoriaElementoArchivo.create({
						archivo: f,
						auditoria_id: auditoria.id
					})
					#agrego a arreglo para asociar aud_elem
					archivos_informe[f.original_filename] = archivo.id
				end

				archivos_evidencia = {}
				auditoria.archivos_evidencia.each do |f|
					#creo archivo
					archivo = AuditoriaElementoArchivo.create({
						archivo: f,
						auditoria_id: auditoria.id
					})
					#agrego a arreglo para asociar aud_elem
					archivos_evidencia[f.original_filename] = archivo.id
				end

				data.each do |fila|
					auditoria_elemento = AuditoriaElemento.find(fila[:auditoria_elemento_id])
					auditoria_elemento.aplica = (fila[:aplica].to_s == "SI")
					auditoria_elemento.motivo = fila[:motivo].to_s
					auditoria_elemento.cumple = (fila[:cumple].to_s == "SI")
					auditoria_elemento.archivo_informe_id = archivos_informe[fila[:nombre_archivo_informe]]
					auditoria_elemento.archivo_evidencia_id = archivos_evidencia[fila[:nombre_archivo_evidencia]]
					auditoria_elemento.fecha_auditoria = fila[:fecha_auditoria].to_s
					auditoria_elemento.rut_auditor = fila[:rut_auditor].to_s
					auditoria_elemento.estado = 2
					auditoria_elemento.save
				end
			end
		end
		auditoria.errors
	end

	def self.dominios
		{
			si_no: ["SI", "NO"]
		}
	end

	def self.datos manif_de_interes, auditoria, adhesion
		
		datos = []
		flujo = Flujo.find_by(manifestacion_de_interes_id: manif_de_interes.id)
		elems_id = []
		# DZC 2018-11-05 14:15:31 se cambia dependencia de manif_de_interes a flujo
		if adhesion.externa
			elementos = adhesion.adhesion_elemento_externos
		else
			elementos = adhesion.adhesion_elementos
		end
		elementos.each do |ae|
			elems_id << ae.id
			propuestas = SetMetasAccion.where(flujo_id: flujo.id).where(alcance_id: ae.alcance_id).all

			propuestas.each do |pro|
				auditoria.auditoria_elementos.find_or_create_by({
					adhesion_elemento_id: ae.id,
					set_metas_accion_id: pro.id
				})
			end
		end

		aud_elem_archivos = AuditoriaElementoArchivo.where(auditoria_id: auditoria.id)
    archivos_auditoria = aud_elem_archivos.count > 0 ? aud_elem_archivos.map{|aea| {aea.id => aea.archivo.identifier}}.inject(:merge) : {}

		auditorias = AuditoriaElemento.where(adhesion_elemento_id: elems_id)
																	.where(auditoria_id: auditoria.id)
																	.all
		auditorias.each do |audit|
			
			elem = audit.adhesion_elemento
			pa = audit.set_metas_accion

			datos_audit = []
			persona = elem.persona
			cont = persona.contribuyente
			datos_audit << cont.rut_completo #0
			datos_audit << cont.razon_social #1
			alcance = elem.alcance
			datos_audit << alcance.nombre #2
			datos_audit << audit.id #3
			case alcance.id
			when Alcance::ORGANIZACION
				datos_audit << elem.fila[:nombre_elemento] #4 
				datos_audit << elem.fila[:tipo_elemento] #5
				datos_audit << elem.fila[:fecha_adhesion] #6
				casa_matriz = cont.direccion_casa_matriz(false, true)
				datos_audit << casa_matriz[:direccion] #7
				datos_audit << casa_matriz[:comuna] #8
			when Alcance::ESTABLECIMIENTO
				datos_audit << elem.fila[:nombre_elemento] #4 
				datos_audit << elem.fila[:tipo_elemento] #5
				ec = elem.establecimiento_contribuyente
				datos_audit << elem.fila[:fecha_adhesion] #6
				datos_audit << ec.direccion #7
				datos_audit << ec.comuna.nombre #8
			when Alcance::MAQUINARIA
				maq = elem.maquinaria
				datos_audit << maq.nombre_maquinaria #4 
				datos_audit << maq.tipo #5
				datos_audit << elem.fila[:fecha_adhesion] #6
				datos_audit << elem.fila[:direccion_instalacion] #7
				datos_audit << elem.fila[:comuna_instalacion] #8
			when Alcance::PRODUCTO
				otro = elem.otro
				datos_audit << otro.nombre #4 
				datos_audit << otro.tipo #5
				datos_audit << elem.fila[:fecha_adhesion] #6
				datos_audit << elem.fila[:direccion_instalacion] #7
				datos_audit << elem.fila[:comuna_instalacion] #8
			else
				datos_audit << elem.fila[:nombre_elemento] #4 
				datos_audit << elem.fila[:tipo_elemento] #5
				datos_audit << elem.fila[:fecha_adhesion] #6
				datos_audit << elem.fila[:direccion_instalacion] #7
				datos_audit << elem.fila[:comuna_instalacion] #8
			end
			datos_audit << persona.user.nombre_completo #9
			datos_audit << persona.persona_cargos.first.cargo.nombre #10
			datos_audit << persona.telefono_institucional #11
			datos_audit << persona.email_institucional #12

			#datos_audit << pa.id #13
			datos_audit << pa.descripcion_accion #14
			datos_audit << pa.detalle_medio_verificacion #15
			datos_audit << "#{pa.plazo_valor} #{I18n.t(pa.plazo_unidad_tiempo)}" #16
			datos_audit << pa.valor_referencia #17
			datos_audit << pa.criterio_inclusion_exclusion #18
			datos_audit << audit.aplica_excell #19
			datos_audit << audit.motivo.presence || "" #20
			datos_audit << audit.cumple_excell #21
			# DZC 2018-11-13 15:43:11 se corrige para el despliegue correcto de los nombres
			
			datos_audit << (audit.archivo_informe_id.present? ? archivos_auditoria[audit.archivo_informe_id] : "") #22
			datos_audit << (audit.archivo_evidencia_id.present? ? archivos_auditoria[audit.archivo_evidencia_id] : "") #23

			datos_audit << audit.fecha_auditoria || "" #24
			datos_audit << audit.rut_auditor || "" #25

			datos << datos_audit
		end
		datos
	end

	def self.de_la_manif_de_interes(manif_de_interes)
		#DZC se ajusta por la desvinculación de la auditoria desde la manifiestación al flujo
		flujo = Flujo.find_by(manifestacion_de_interes_id: manif_de_interes.id)

		# ae = manif_de_interes.adhesion.adhesion_elementos.map{|ae| ae.id}

		ae = flujo.adhesion.adhesion_elementos.map{|ae| ae.id}

		Auditoria.where(adhesion_elemento_id: ae).includes([:set_metas_accion, {adhesion_elemento: [{persona: [:user, :contribuyente]}, :alcance]}])
	end

	def self.datos_ppf flujo, establecimiento
		datos = []
		elems_id = []
		adhesion_elementos = []
		if flujo.adhesion.present?
			adhesion_elementos = flujo.adhesion.adhesion_elementos.where(establecimiento_contribuyente_id: establecimiento.id)
		end
		adhesion_elementos.each do |ae|
			elems_id << ae.id
			propuestas = SetMetasAccion.where(flujo_id: flujo.id).where(alcance_id: ae.alcance_id).where(estado: 3).all
			
			propuestas.each do |pro|
				
				AuditoriaElemento.where(auditoria_id: flujo.auditorias.first.id, set_metas_accion_id: pro.id, adhesion_elemento_id: ae.id).first_or_create
			end
		end

		auditorias = AuditoriaElemento.where(adhesion_elemento_id: elems_id).where(estado: [1, 3]).all

		auditorias.each do |audit|
			elem = audit.adhesion_elemento
			pa = audit.set_metas_accion

			datos_audit = []
			persona = elem.persona
			cont = persona.contribuyente
			datos_audit << cont.rut_completo #0
			datos_audit << cont.razon_social #1
			alcance = elem.alcance
			datos_audit << alcance.nombre #2
			datos_audit << audit.id #3
			case alcance.id
			when Alcance::ORGANIZACION
				datos_audit << "" #4 
				datos_audit << "" #5
				datos_audit << elem.created_at.strftime("%F") #6
				casa_matriz = cont.direccion_casa_matriz(false, true)
				datos_audit << casa_matriz[:direccion] #7
				datos_audit << casa_matriz[:comuna] #8
			when Alcance::ESTABLECIMIENTO
				datos_audit << "" #4 
				ec = elem.establecimiento_contribuyente
				datos_audit << ec.tipo_de_establecimiento #5
				datos_audit << elem.created_at.strftime("%F") #6
				datos_audit << ec.direccion #7
				datos_audit << ec.comuna.nombre #8
			when Alcance::MAQUINARIA
				maq = elem.maquinaria
				datos_audit << maq.nombre_maquinaria #4 
				datos_audit << maq.tipo #5
				datos_audit << elem.created_at.strftime("%F") #6
				datos_audit << "" #7
				datos_audit << "" #8
			when Alcance::PRODUCTO
				otro = elem.otro
				datos_audit << otro.nombre #4 
				datos_audit << otro.tipo #5
				datos_audit << elem.created_at.strftime("%F") #6
				datos_audit << "" #7
				datos_audit << "" #8
			end
			datos_audit << persona.user.nombre_completo #9
			datos_audit << persona.persona_cargos.first.cargo.nombre #10
			datos_audit << persona.telefono_institucional #11
			datos_audit << persona.email_institucional #12

			#datos_audit << pa.id #13
			datos_audit << pa.descripcion_accion #14
			datos_audit << pa.detalle_medio_verificacion #15
			datos_audit << "#{pa.plazo_valor} #{I18n.t(pa.plazo_unidad_tiempo)}" #16
			datos_audit << pa.valor_referencia #17
			datos_audit << pa.criterio_inclusion_exclusion #18
			datos_audit << (audit.aplica.present? ? (audit.aplica ? 'SI' : 'NO') : "SI") #19
			datos_audit << audit.motivo #20
			datos_audit << (audit.cumple.present? ? (audit.cumple ? 'SI' : 'NO') : "NO") #21
			datos_audit << (audit.archivo_informe.present? ? audit.archivo_informe_identifier : "") #22
			datos_audit << (audit.archivo_evidencia.present? ? audit.archivo_evidencia_identifier : "") #23
			datos_audit << audit.fecha_auditoria #24
			datos_audit << audit.rut_auditor #25

			datos << datos_audit
		end
		datos
	end

	def aceptada_or_rechazada
		if self.estado == 5
			self.aprobacion_fecha = DateTime.now
		else
			self.aprobacion_fecha == nil
		end
	end

  #DZC se obtienen label para reporte automatizado de avances
  def nombre_para_raa
    return "ID #{self.id} - #{(self.auditoria.nombre.blank? ? 'Auditoria sin nombre': self.auditoria.nombre)} - #{self.flujo.tipo_de_flujo} - #{self.flujo.nombre_instrumento}"
  end
  #Devuelve el campo aplica en string, de estar en blanco devuelve por defecto
  def aplica_excell
  	unless self.aplica.nil?  		
  		if aplica
  			"SI"
  		else
  			"NO"
  		end
  	else
  		"SI"
  	end
  end

  #Devuelve el campo cumple en string, de estar en blanco devuelve por defecto
  def cumple_excell
  	unless self.cumple.nil?  		
  		if cumple
  			"SI"
  		else
  			"NO"
  		end
  	else
  		"NO"
  	end
  end

end
