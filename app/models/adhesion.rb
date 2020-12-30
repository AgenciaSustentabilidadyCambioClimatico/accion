class Adhesion < ApplicationRecord

	has_many :adhesion_elementos, dependent: :destroy
	has_many :adhesion_elemento_retirados, dependent: :destroy
	# belongs_to :manifestacion_de_interes
	belongs_to :flujo

	mount_uploaders :archivos_adhesion_y_documentacion, ArchivoAdhesionYDocumentacionAdhesionesUploader
	mount_uploader :archivo_elementos, ArchivoElementosAdhesionesUploader

	validate :data_adhesiones, unless: -> { tipo.present? }
	validates :estado_elementos, presence: true, if: -> { validar_clasificar}
	validates :justificacion_elementos, presence: true, if: -> { estado_elementos == "false" && validar_clasificar}

	serialize :adhesiones_data

	attr_accessor :aceptado, :observacion, :tipo, :is_ppf
	attr_accessor :estado_elementos, :justificacion_elementos, :elementos_seleccionados, :validar_clasificar
	attr_accessor :documento_justificacion, :elemento_retirado_id, :validar_retirar

	mount_uploader :documento_justificacion, ArchivoAdhesionYDocumentacionAdhesionesUploader


	def self.columnas_excel
		{
			fecha_adhesion: nil, #0
			rut_institucion: nil, #1
			nombre_institucion: nil, #2
			sector_productivo: "sectores", #3
			tipo_institucion: "tipo_instituciones", #4
			tamaño_empresa: "rango_empresa", #5
			direccion_casa_matriz: nil, #6
			comuna_casa_matriz: "comunas", #7
			rut_encargado: nil, #8
			nombre_encargado: nil, #9
			cargo_encargado: "cargos", #10
			fono_encargado: nil, #11
			email_encargado: nil, #12
			alcance: "alcances", #13
			nombre_instalacion: nil, #14
			direccion_instalacion: nil, #15
			comuna_instalacion: "comunas", #16
			tipo_elemento: nil, #17
			identificador: nil, #18
			patente: nil, #19
			nombre_elemento: nil, #20
			nombre_archivo: nil #21
		} 
	end

	def self.columnas_excel_descarga
		{
			fecha_adhesion: nil, #0
			rut_institucion: nil, #1
			nombre_institucion: nil, #2
			sector_productivo: nil, #3
			tipo_institucion: nil, #4
			tamaño_empresa: nil, #5
			direccion_casa_matriz: nil, #6
			comuna_casa_matriz: nil, #7
			rut_encargado: nil, #8
			nombre_encargado: nil, #9
			cargo_encargado: nil, #10
			fono_encargado: nil, #11
			email_encargado: nil, #12
			alcance: nil, #13
			nombre_instalacion: nil, #14
			direccion_instalacion: nil, #15
			comuna_instalacion: nil, #16
			tipo_elemento: nil, #17
			identificador: nil, #18
			patente: nil, #19
			nombre_elemento: nil, #20
			nombre_archivo: nil #21
		} 
	end

	def parsear_adhesiones
		header = Adhesion.columnas_excel.map{|k,v| k}
		ExcelParser.new(self.archivo_elementos,header).tabulated
	end

	def desparseas_adhesiones_rechazadas
		self.adhesiones_por_revisar.map{ |ac|
			ac.except(:revisado, :observaciones, :posicion).map{|k,v| v}
		}
	end

	# Valida linea por linea los campos del archivo
	# se transforma de archivo a hash en metodo 'parsear_adhesiones'
	def data_adhesiones #APl-025
		data = parsear_adhesiones
		archivo_correcto = true
		if data.size <= 0
			errors.add(:archivo_elementos, "Debe indicar al menos una adhesion")
		else
			errores=Adhesion.columnas_excel.transform_values{|v| []}
			errores.store(:base, [])
			instituciones_con_archivo = []

			data.each_with_index do |fila, posicion|

				# DZC 2019-06-11 15:41:28 se agrega para evitar errores en lectura y problamiento de tablas
		    fila_identificador = fila[:identificador].present? ? fila[:identificador].to_s : fila[:identificador]
		    fila_patente = fila[:patente].present? ? fila[:patente].to_s : fila[:patente]

				if fila[:fecha_adhesion].blank? || fila[:rut_institucion].blank? || fila[:tipo_institucion].blank? || fila[:rut_encargado].blank? || 
					fila[:alcance].blank? || fila[:sector_productivo].blank? || fila[:tamaño_empresa].blank? || 
					fila[:comuna_casa_matriz].blank? || fila[:cargo_encargado].blank?
					errores[:base] << " El archivo contiene celdas base sin completar, para la fila #{(posicion+2)}"
				else
					rut_institucion = fila[:rut_institucion].to_s.gsub('k', 'K')
					# DZC 2019-06-19 11:18:31 se modifica para que exista coherencia entre las comparaciones de RUT
					# rut_encargado = fila[:rut_encargado].to_s.gsub('k', 'K')
					fila[:rut_encargado] = fila[:rut_encargado].to_s.gsub('k', 'K')
					rut_encargado = fila[:rut_encargado]

					contribuyente = nil
					# valida institucion (si existe y si estan sus campos)
					if !rut_institucion.rut_valid?
						errores[:rut_institucion] << " El archivo contiene un formato de RUT invalido, para la fila #{(posicion+2)}"
					else
						contribuyente = Contribuyente.find_by(rut: rut_institucion.split('-')[0])
						if contribuyente.nil?
							if fila[:direccion_casa_matriz].blank?
								errores[:direccion_casa_matriz] << " El archivo contiene celdas base sin completar, para la fila #{(posicion+2)}"
							elsif fila[:nombre_institucion].blank?
								errores[:nombre_institucion] << " Debe completar la celda Nombre institucion para línea #{(posicion+2)}"
							else
								if ActividadEconomica.where(codigo_ciiuv4: fila[:sector_productivo]).first.nil?
									errores[:sector_productivo] << fila[:sector_productivo]
								end
								if TipoContribuyente.where(nombre: fila[:tipo_institucion]).first.nil?
									errores[:tipo_institucion] << fila[:tipo_institucion]
								end
								tamano_empresa_split = fila[:tamaño_empresa].split('-')
								if RangoVentaContribuyente.find_by(venta_anual_en_uf: tamano_empresa_split.last).nil?
									errores[:tamaño_empresa] << fila[:tamaño_empresa]
								end
								if Comuna.find_by(nombre: fila[:comuna_casa_matriz]).nil?
									errores[:comuna_casa_matriz] << fila[:comuna_casa_matriz]
								end
							end
						else
							data[posicion][:nombre_institucion] = contribuyente.razon_social
						end
					end

					user = nil		
					# validaciones del encargado
					emails = data.map{|d| d[:email_encargado]}
					if emails.include?(fila[:email_encargado])
						temp = data.map{|d| [d[:rut_encargado],d[:email_encargado]]}
						#obtengo todos los que hacen match con el email
						temp_filtro = temp.select{|t| t.last == fila[:email_encargado]}
						#Verifico aquellos que tenga el mismo rut
						temp_final = temp_filtro.select{|t| t.first == rut_encargado}
						unless temp_filtro.size == temp_final.size
							errores[:email_encargado] << " El RUT del encargado de la fila #{(posicion+2)} tiene asociado otro email"
							archivo_correcto = false
						end
					end
					
					# DZC 2018-10-20 18:38:57 se modifican las validaciones a fin de considerar la preexistencia de email y rut en forma conjunta, por que configuran la llave primaria de la tabla users
					if !fila[:email_encargado].to_s.email_valid?
						# errores[:email_encargado] << fila[:email_encargado]
						errores[:email_encargado] << " El eMail del encargado para la línea #{(posicion+2)} es inválido"					
					elsif !rut_encargado.rut_valid?
						# errores[:rut_encargado] << fila[:rut_encargado]
						# errors.add(:archivo_elementos, "El RUT del encargado para la línea #{(posicion+2)} es inválido")
						errores[:rut_encargado] << " El RUT del encargado para la línea #{(posicion+2)} es inválido"	
					else 
						user = User.find_by(rut: rut_encargado, email: fila[:email_encargado].to_s)
						if user.blank?
							if User.find_by(email: fila[:email_encargado].to_s).present?
								# errores[:email_encargado] << fila[:email_encargado]
								# errors.add(:archivo_elementos, "El eMail del encargado para la línea #{(posicion+2)}, ya existe en la base de datos de usuarios")
								errores[:email_encargado] << " El eMail del encargado para la línea #{(posicion+2)}, ya existe en la base de datos de usuarios, asociado a otro usuario"	
							elsif User.find_by(rut: rut_encargado).present?
								# errores[:rut_encargado] << fila[:rut_encargado]
								# errors.add(:archivo_elementos, "El RUT del encargado para la línea #{(posicion+2)}, ya existe en la base de datos de usuarios")
								errores[:rut_encargado] << " El RUT del encargado para la línea #{(posicion+2)}, ya existe en la base de datos de usuarios"	
							elsif fila[:nombre_encargado].blank? || fila[:fono_encargado].blank? || fila[:email_encargado].blank?
								# errors.add(:archivo_elementos, "Debe completar las celdas Nombre encargado, Fono encargado y Email encargado para la línea #{(posicion+2)}")
								errores[:nombre_encargado] << " Debe completar las celdas Nombre encargado, Fono encargado y Email encargado para la línea #{(posicion+2) }"	
							else
								if Cargo.find_by(nombre: fila[:cargo_encargado]).blank?
									errores[:cargo_encargado] << fila[:cargo_encargado]
								end

								unless fila[:fono_encargado].to_s.phone_valid?
									errores[:fono_encargado] << fila[:fono_encargado]
								end
							end
						else
							data[posicion][:nombre_encargado] = user.nombre_completo
							data[posicion][:fono_encargado] = user.telefono
						end
					end

					if Alcance.find_by(nombre: fila[:alcance]).blank?
						alcances_invalidos << fila[:alcance]
					else
						if is_ppf
							if fila[:alcance].to_s == "Establecimiento"
								if fila[:nombre_instalacion].blank?
									errores[:nombre_instalacion] << " Debe completar la celda Nombre instalacíon para línea #{(posicion+2)}"
								else 
									#DZC Se elimina la validación de que el establecimiento del contribuyente exista
									# ec = nil
									# unless contribuyente.nil?
									# 	ec = EstablecimientoContribuyente.where(contribuyente_id: contribuyente.id).where(nombre_de_establecimiento: fila[:nombre_instalacion]).first
									# end
									# if ec.nil?
									# 	if !fila[:direccion_instalacion].blank? 
									# 		errores[:direccion_instalacion] << fila[:direccion_instalacion]
									# 	end
									# 	if !fila[:comuna_instalacion].blank? || Comuna.find_by(nombre: fila[:comuna_instalacion]).nil?
									# 		errores[:comuna_instalacion] << fila[:comuna_instalacion]
									# 	end
									# 	if !fila[:tipo_elemento].blank? 
									# 		errores[:tipo_elemento] << fila[:tipo_elemento]
									# 	end
									# end

									#DZC se agregan validaciones para campos vacios
									if fila[:direccion_instalacion].blank? 
										errores[:direccion_instalacion] << " Debe completar la celda 'Dirección instalacíon' para línea #{(posicion+2)}"
									end
									if fila[:comuna_instalacion].blank? || Comuna.find_by(nombre: fila[:comuna_instalacion]).nil?
										errores[:comuna_instalacion] << "Debe completar la celda 'Comuna instalacíon' para línea #{(posicion+2)} "
									end
								end
							else
								errores[:alcance] << " Alcance incorrecto, solo es posible adherir establecimientos"
							end
						else
							case fila[:alcance].to_s
							when "Organización"
								# TODO: Validar organizacion
							when "Establecimiento"
								if fila[:nombre_instalacion].blank?
									errores[:nombre_instalacion] << " Debe completar la celda Nombre instalacíon para línea #{(posicion+2)}"
								else 
									#DZC Se elimina la validación de existencia del nombre del establecimiento, pues si no existe se debe crear
									# ec = nil
									# unless contribuyente.nil?
									# 	ec = EstablecimientoContribuyente.where(contribuyente_id: contribuyente.id).where(nombre_de_establecimiento: fila[:nombre_instalacion]).first
									# end
									# if ec.nil?  
									# if !fila[:direccion_instalacion].blank? 
									# 	if !fila[:direccion_instalacion].blank? 										
									# 		errores[:direccion_instalacion] << fila[:direccion_instalacion]
									# 	end
									# 	if !fila[:comuna_instalacion].blank? || Comuna.find_by(nombre: fila[:comuna_instalacion]).nil?
									# 		errores[:comuna_instalacion] << fila[:comuna_instalacion]
									# 	end
									# 	if !fila[:tipo_elemento].blank? 
									# 		errores[:tipo_elemento] << fila[:tipo_elemento]
									# 	end
									# end

									#DZC se agregan validaciones para campos vacios
									if fila[:direccion_instalacion].blank? 
										errores[:direccion_instalacion] << " Debe completar la celda 'Dirección instalacíon' para línea #{(posicion+2)}"
									end
									if fila[:comuna_instalacion].blank? || Comuna.find_by(nombre: fila[:comuna_instalacion]).nil?
										errores[:comuna_instalacion] << " Debe completar la celda 'Comuna instalacíon' para línea #{(posicion+2)}"
									end								
								end
							when "Maquinaria"
								if fila_identificador.blank? && fila_patente.blank?
									errores[:identificador] << " Debe completar las celdas Identificador o Patente para línea #{(posicion+2)}"
								else 

									mq = nil
									unless contribuyente.blank?

										# DZC 2019-06-06 13:46:13 se setean como texto los datos identificador y patente
										mq = Maquinaria.where(contribuyente_id: contribuyente.id).where("numero_serie = ? OR patente = ?", fila_identificador, fila_patente).first
									end
									if mq.blank?
										if fila[:nombre_elemento].blank?
											errores[:nombre_elemento] << " Debe completar la celda Nombre elemento para línea #{(posicion+2)}"
										end
									end
								end
							when "Producto"
								#no se realiza nada
							else
								if fila_identificador.blank?
									errores[:identificador] << " Debe completar las celdas Identificador para línea #{(posicion+2)}"
								end
							end
						end
					end

					if fila[:nombre_archivo].blank?
						unless instituciones_con_archivo.include?(rut_institucion)
							unless contribuyente.blank?
								personas = Persona.where(contribuyente_id: contribuyente.id).pluck(:id)
								if AdhesionElemento.where(persona_id: personas).where.not(archivo_respaldo: nil).size == 0
									errores[:nombre_archivo] << " Debe completar la celda Nombre archivo para línea #{(posicion+2)}"
								else
									instituciones_con_archivo << rut_institucion
								end
							else
								errores[:nombre_archivo] << " Debe completar la celda Nombre archivo para línea #{(posicion+2)}"
							end
						end
					else
						if !self.archivos_adhesion_y_documentacion.map{|ar| ar.file.identifier}.include? fila[:nombre_archivo]
							errores[:nombre_archivo] << " Archivo #{fila[:nombre_archivo]}, indicado en línea #{(posicion+2)}, no se encontró en los archivos que se subieron"
						else
							instituciones_con_archivo << rut_institucion
						end
					end
				end
			end
			#DZC 2018-10-20 19:58:54 se verifica que no hayan eMails repetidos en el archivo
			# 
			# emails = data.map{|d| [d[:email_encargado], d[:rut_encargado]]}
			# if emails.uniq.size != emails.size
			# 	errores.add(:archivo_elementos, "El archivo contiene eMails repetidos, por favor indicar un correo distinto por cada actor")
			# 	archivo_correcto = false
			# end			

			# errores.each do |k,v|
			# 	if v.size > 0
			# 		errors.add(:archivo_elementos, "El archivo contiene #{k.to_s.humanize} inválid@(s): #{v.join(',')}")
			# 		archivo_correcto = false
			# 	end
			# end
			primera = true
			@resultado = nil
			errores.each do |k,v|
				if v.size > 0
					if primera
						@resultado = "Han surgido los siguientes conflictos: #{v.join(',')}"
						primera = false
					else
						@resultado += ", #{v.join(',')}"						
					end
					archivo_correcto = false
				end								
			end
			
			if @resultado.present?
				errors.add(:archivo_elementos, @resultado)
			end
			if archivo_correcto
				data.each_with_index.map{|v, k|
					v[:revisado] = false
					v[:observaciones] = nil
					v[:posicion] = k
					v
				}
				self.adhesiones_data = data
			end

		end
	end

	def self.dominios(is_ppf=false)
		if is_ppf
			{			
				sectores: ActividadEconomica.order(codigo_ciiuv4: :asc).map {|ac| ac.codigo_ciiuv4.to_s}.compact,
				tipo_instituciones: TipoContribuyente.order(nombre: :asc).map {|ti| ti.nombre}.compact,
				comunas: Comuna.order(nombre: :asc).map {|c| c.nombre}.compact,
				cargos: Cargo.order(nombre: :asc).map {|c| c.nombre}.compact,
				alcances: Alcance.where(id: 2).map {|c| c.nombre}.compact,
				rango_empresa: RangoVentaContribuyente.all.map {|c| "#{c.rango}-#{c.tamano_contribuyente.nombre}-#{c.venta_anual_en_uf}"}.compact,
			}
		else
			{			
				sectores: ActividadEconomica.order(codigo_ciiuv4: :asc).map {|ac| ac.codigo_ciiuv4.to_s}.compact,
				tipo_instituciones: TipoContribuyente.order(nombre: :asc).map {|ti| ti.nombre}.compact,
				comunas: Comuna.order(nombre: :asc).map {|c| c.nombre}.compact,
				cargos: Cargo.order(nombre: :asc).map {|c| c.nombre}.compact,
				alcances: Alcance.order(nombre: :asc).map {|c| c.nombre}.compact,
				rango_empresa: RangoVentaContribuyente.all.map {|c| "#{c.rango}-#{c.tamano_contribuyente.nombre}-#{c.venta_anual_en_uf}"}.compact,
			}
		end
	end

	def adhesiones_rechazadas
		filas = []
		self.adhesion_elementos.each do |ae|
			filas << ae.fila.except(:revisado, :observaciones)
		end
		unless self.new_record?
			self.adhesiones_data.select{|fila| 
				fila[:revisado] == true #&& !filas.include?(fila.except(:revisado, :observaciones))
			}
		else
			[]
		end
	end

	#Son todas aquellas adhesiones que no han sido aprobadas.-
	def adhesiones_por_revisar
		self.new_record? ? [] : self.adhesiones_data.select{|v| v[:revisado] == false}
	end

	def adhesiones_pendientes
		if self.persisted?
			self.adhesiones_data.select{|fila| fila[:revisado] == false && fila[:observaciones] == nil }
		else
			[]
		end
	end

	def adhesiones_observadas
		if self.persisted?
			self.adhesiones_data.select{|fila| fila[:revisado] == false && fila[:observaciones] != nil }
		else
			[]
		end
	end

	def adhesiones_aceptadas
		if self.persisted?
			self.adhesion_elementos.map{ |a|
				fila = a.fila
				fila[:id] = a.id
				fila
			}
		else
			[]
		end
	end

	def adhesiones_retiradas
		if self.persisted?
			self.adhesion_elemento_retirados.map{|a| 
				fila = a.fila
				fila[:documento_justificacion] = a.archivo_retiro
				fila
			}
		else
			[]
		end
	end

	def adhesiones_aceptadas_y_observadas
		{ aceptada: adhesiones_aceptadas, observada: adhesiones_observadas}
	end

	def adhesiones_todas
		{ aceptada: adhesiones_aceptadas, observada: adhesiones_observadas, pendiente: adhesiones_pendientes}
	end

	def poblar_data(fila, flujo) #PPF-017 APL-028

		archivo_adhesion = nil
		archivo_respaldo = nil
    self.archivos_adhesion_y_documentacion.each do |f|
    	archivo_adhesion = f if f.file.filename.split(".")[0] == "adhesion"
      archivo_respaldo = f if f.file.filename == fila[:nombre_archivo]
    end

    # DZC 2019-06-11 15:41:28 se agrega para evitar errores en lectura y problamiento de tablas
    fila_identificador = fila[:identificador].present? ? fila[:identificador].to_s : fila[:identificador]
    fila_patente = fila[:patente].present? ? fila[:patente].to_s : fila[:patente]

    contribuyente = Contribuyente.find_by(rut: (fila[:rut_institucion][0,fila[:rut_institucion].length-2].to_i))
		if contribuyente.nil?
			contribuyente = Contribuyente.new(
				rut: (fila[:rut_institucion][0,fila[:rut_institucion].length-2]).to_i,
				dv: (fila[:rut_institucion][fila[:rut_institucion].length-1,1]).to_s.gsub(/k/,'K'),
				razon_social: fila[:nombre_institucion].to_s
				)
			contribuyente.save(validate: false)
		end

		actividad_economica = ActividadEconomica.find_by(codigo_ciiuv4: fila[:sector_productivo])
		aaeec = contribuyente.actividad_economica_contribuyentes.where(actividad_economica_id: actividad_economica.id).first
		if aaeec.blank? 
			aaeec = ActividadEconomicaContribuyente.new(
				actividad_economica_id: actividad_economica.id,
				contribuyente_id: contribuyente.id
				)
			aaeec.save(validate: false)
		end

		#DZC (3) verifica que el contribuyente y el tipo de contribuyente esten relacionados según la tabla dato anual contribuyente 
		# DZC 2019-05-20 12:25:19 se modifica para evitar búsquedas case sensitive
		# tipo_contribuyente = TipoContribuyente.find_by(nombre: fila[:tipo_institucion].to_s)
		tipo_contribuyente = TipoContribuyente.find_by('nombre ILIKE ?', fila[:tipo_institucion].to_s)

		tamano_empresa_split = fila[:tamaño_empresa].split('-')

		# DZC 2019-05-20 12:34:43 se modifica para evitar búsquedas case sensitive
		# rango_venta_contribuyente = RangoVentaContribuyente.find_by(venta_anual_en_uf: tamano_empresa_split.last)
		rango_venta_contribuyente = RangoVentaContribuyente.find_by('venta_anual_en_uf ILIKE ?', tamano_empresa_split.last)
		# 
		datos_anuales_contribuyente = contribuyente.dato_anual_contribuyentes.where(tipo_contribuyente_id: tipo_contribuyente.id).where(rango_venta_contribuyente_id: rango_venta_contribuyente.id).first
		if datos_anuales_contribuyente.blank?
			datos_anuales_contribuyente = DatoAnualContribuyente.new(
				contribuyente_id: contribuyente.id,
				tipo_contribuyente_id: tipo_contribuyente.id,
				rango_venta_contribuyente_id: rango_venta_contribuyente.id
				)
			datos_anuales_contribuyente.save(validate: false)
		end

		#DZC (4) verifica la ubicación del contribuyente y en caso de ausencia crea y asocia el establecimiento.

		# DZC 2019-05-20 12:04:40 se modifica para evitar comparación de comunas case sensitive
		# comuna = Comuna.where(nombre: fila[:comuna_casa_matriz].to_s).includes(provincia: [region: [:pais]]).where({"paises.nombre" => "Chile"}).first #modificar para el caso de que puedan existir comunas repetidas
		comuna = Comuna.where('comunas.nombre ILIKE ?', fila[:comuna_casa_matriz].to_s).includes(provincia: [region: [:pais]]).where({"paises.nombre" => "Chile"}).first #modificar para el caso de que puedan existir comunas repetidas

		#DZC se agrega la dirección en la búsqueda de la casa matríz
		establecimiento_contribuyente = contribuyente.establecimiento_contribuyentes.where(comuna_id: comuna.id, direccion: fila[:direccion_casa_matriz].to_s).first
		if establecimiento_contribuyente.nil?
			establecimiento_contribuyente = EstablecimientoContribuyente.new(
				contribuyente_id: contribuyente.id,
				casa_matriz: true,
				direccion: fila[:direccion_casa_matriz].to_s,
				pais_id: comuna.provincia.region.pais.id,
				region_id: comuna.provincia.region.id,
				comuna_id: comuna.id
				)
			establecimiento_contribuyente.save(validate: false)
		end

		# DZC (5) se busca la existencia del usuario y persona, en caso de ausencia se crean.

		# DZC 2018-10-20 19:45:45 se consideran el rut y el email en conjunto para la búsqueda del usuario
		usuario = User.find_by(rut: fila[:rut_encargado].to_s, email: fila[:email_encargado].to_s)
		if usuario.blank?
			# Crea un usuario sin password y le envia la invitación al email
			usuario = User.invite!(
				rut: fila[:rut_encargado].to_s.gsub(/k/,'K'),
				nombre_completo: fila[:nombre_encargado].to_s,
				telefono: fila[:fono_encargado].to_s,
				email: fila[:email_encargado].to_s)
		end
		persona = usuario.personas.where(contribuyente_id: contribuyente.id).first
		if persona.nil?
			persona = Persona.new(
				user_id: usuario.id,
				contribuyente_id: contribuyente.id,
				# establecimiento_contribuyente_id: establecimiento_contribuyente.id,
				email_institucional: fila[:email_encargado].to_s,
				telefono_institucional: fila[:fono_encargado].to_s
				)
			persona.save(validate: false)
		end

		#DZC (6) se busca la existencia del rol

		# DZC 2019-05-20 12:27:40 se modifica para evitar búsquedas case sensitive
		# cargo = Cargo.find_by(nombre: fila[:cargo_encargado].to_s)
		cargo = Cargo.find_by('nombre ILIKE ?', fila[:cargo_encargado].to_s)

		persona_cargo = persona.persona_cargos.where(cargo_id: cargo.id).first if cargo.present?
		if persona_cargo.nil?
			persona_cargo = PersonaCargo.new(
				persona_id: persona.id,
				cargo_id: cargo.id
				)
			persona_cargo.save(validate: false)
		end

		MapaDeActor.find_or_create_by(
			flujo_id: flujo.id,
			persona_id: persona.id,
			rol_id: Rol::RESPONSABLE_CUMPLIMIENTO_COMPROMISOS
		)

		# DZC 2019-05-20 12:29:42 se modifica para evitar búsquedas case sensitive
		# alcance = Alcance.find_by(nombre: fila[:alcance].to_s)
		alcance = Alcance.find_by('nombre ILIKE ?', fila[:alcance].to_s)

		establecimiento_alcance = nil
		maquinaria = nil
		otro = nil
		#alcance
		case alcance.id
		when Alcance::ORGANIZACION
			# NADA
		when Alcance::ESTABLECIMIENTO
			# DZC 2019-05-20 12:18:25 se modifica para evitar comparación de comunas case sensitive
			# comuna = Comuna.where(nombre: fila[:comuna_instalacion].to_s).includes(provincia: [region: [:pais]]).where({"paises.nombre" => "Chile"}).first #modificar para el caso de que puedan existir comunas repetidas
			comuna = Comuna.where('comunas.nombre ILIKE ?', fila[:comuna_instalacion].to_s).includes(provincia: [region: [:pais]]).where({"paises.nombre" => "Chile"}).first #modificar para el caso de que puedan existir comunas repetidas
			establecimiento_alcance = contribuyente.establecimiento_contribuyentes.where(comuna_id: comuna.id, direccion: fila[:direccion_instalacion].to_s).first			
			if establecimiento_alcance.blank?
				establecimiento_alcance = EstablecimientoContribuyente.new(
					contribuyente_id: contribuyente.id,
					casa_matriz: false,
					direccion: fila[:direccion_instalacion].to_s,
					pais_id: comuna.provincia.region.pais.id,
					region_id: comuna.provincia.region.id,
					comuna_id: comuna.id,
					nombre_de_establecimiento: fila[:nombre_instalacion].to_s,
					tipo_de_establecimiento: fila[:tipo_elemento].to_s
					)
				establecimiento_alcance.save(validate: false)		
			else
				if establecimiento_alcance.tipo_de_establecimiento.blank? && fila[:tipo_elemento].present?
					establecimiento_alcance.update(tipo_de_establecimiento: fila[:tipo_elemento].to_s)	
				end	
				if establecimiento_alcance.nombre_de_establecimiento.blank? && fila[:nombre_instalacion].present?
					establecimiento_alcance.update(nombre_de_establecimiento: fila[:nombre_instalacion].to_s)	
				end
			end
			persona.update(establecimiento_contribuyente_id: establecimiento_alcance.id)
		when Alcance::MAQUINARIA
			maquinaria = Maquinaria.where(contribuyente_id: contribuyente.id).where("numero_serie = ? OR patente = ?", fila_identificador, fila_patente ).first
			if maquinaria.nil?
				maquinaria = Maquinaria.new(
					establecimiento_contribuyente_id: establecimiento_contribuyente.id,
					contribuyente_id: contribuyente.id,
					nombre_maquinaria: fila[:nombre_elemento].to_s,
					numero_serie: fila_identificador,
					patente: fila_patente,
					tipo: fila[:tipo_elemento].to_s
				)
				maquinaria.save(validate: false)
			end
		else
			otro = Otro.find_by(identificador_unico: fila_identificador)
			if otro.nil?
				otro = Otro.new(
					establecimiento_contribuyente_id: establecimiento_contribuyente.id,
					alcance_id: alcance.id,
					contribuyente_id: contribuyente.id,
					nombre: fila[:nombre_elemento].to_s,
					tipo: fila[:tipo_elemento].to_s,
					identificador_unico: fila_identificador
				)
				otro.save(validate: false)
			end
		end

    adhesion_elemento = self.adhesion_elementos.new({
    	persona_id: persona.id,
    	alcance_id: alcance.id,
    	establecimiento_contribuyente_id: establecimiento_alcance.nil? ? nil : establecimiento_alcance.id,
    	maquinaria_id: maquinaria.nil? ? nil : maquinaria.id,
    	otro_id: otro.nil? ? nil : otro.id,
	    fila: fila,
	    archivo_adhesion: archivo_adhesion,
	    archivo_respaldo: archivo_respaldo
    })
    #Cada vez que en la tabla “Adhesión_elementos” se hayan creado registros, entonces se debe poblar la tabla Datos Productivos Elementos Adheridos, pero solo para los APL
    if adhesion_elemento.save  
    	#Valido que sea APL 
    	if adhesion_elemento.adhesion.flujo.apl?
	    	#Obtengo todas las actividades economicas asociadas al contribuyente
	    	contribuyente = adhesion_elemento.persona.contribuyente
	    	actividades_economicas = ActividadEconomicaContribuyente.where(contribuyente_id: contribuyente.id)
	    	#Obtengo todas las propuesta de acuerdo, que tengan relación con este elemento adherido
	    	
	    	#DZC
	    	flujo = self.flujo
	    	manifestacion = self.flujo.manifestacion_de_interes
	    	# manifestacion = self.manifestacion_de_interes
	    	
	    	# propuestas_de_acuerdos = SetMetasAccion.where(manifestacion_de_interes_id: manifestacion.id)
	    	propuestas_de_acuerdos = SetMetasAccion.where(flujo_id: flujo.id)

	    	propuestas_de_acuerdos.each do |propuesta|
	    		if propuesta.ppf_metas_establecimiento_id.present?
	    			alcance = Alcance::ESTABLECIMIENTO
	    		else
	    			alcance = propuesta.alcance_id
	    		end
	    		if (alcance == adhesion_elemento.alcance_id)
		    		ms = propuesta.materia_sustancia
		    		if ms.present?
			    		#Busco todas las MateriasRubroRelacions existen deacuerdo a la materia y las actividades economicas del contribuyente.-
			    		actividades_economicas.each do |ae|
			    			materia_rubro_relacion = MateriaRubroRelacion.where(materia_sustancia_id: ms.id, actividad_economica_id: ae.actividad_economica_id).first
			    			if materia_rubro_relacion.present?
				    			#Obtengo todos los datos relacionadoes segun el rubro y materia.-
				    			materia_rubro_dato_relaciones = materia_rubro_relacion.materia_rubro_dato_relacions
				    			materia_rubro_dato_relaciones.each do |mrdr|		
				    				mrdr.dato_recolectado.dato_productivo_elemento_adheridos.create(adhesion_elemento_id: adhesion_elemento.id, set_metas_accion_id: propuesta.id)
				    			end
				    		end
			    		end
			    	end
		    	end
    		end
    	end
    end
    adhesion_elemento
	end	

end
