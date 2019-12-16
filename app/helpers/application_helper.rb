module ApplicationHelper

	def titulo(string)
    content_for(:titulo){ string }
    content_for(:head_title){ string }
  end

	def can_see(link)
		true
	end

	def can_delete?(object, id=nil)
		true
	end

	def can_edit_profile?
		true
	end

	def __normalize_as_(string)
		lowercases = [:del,:de,:en,:y,:o,:e]
		string.split(/ |\_|\-/).map(&:capitalize).join(" ").split(" ").map{|m|
			if lowercases.include?(m.downcase.to_sym)
				m.downcase
			else
				m
			end
		}.join(" ")
		string
	end

	def obtener_grupo_(proyecto)
		grupo = nil
		if proyecto.iniciado
			grupo = :iniciados
		elsif proyecto.oculto == true
			grupo = :ocultos
		elsif proyecto.oculto == false
			grupo = :visibles
		end
		grupo
	end

	#
  # http://stackoverflow.com/questions/19595840/rails-get-the-time-difference-in-hours-minutes-and-seconds
  #
  def timelapse(start_time, end_time)
    ApplicationHelper.timelapse?(start_time, end_time)
  end

  def self.timelapse(start_time, end_time)
	  seconds_diff = (start_time - end_time).to_i.abs
	  hours = seconds_diff / 3600
	  seconds_diff -= hours * 3600
	  minutes = seconds_diff / 60
	  seconds_diff -= minutes * 60
	  seconds = seconds_diff
	  "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  end

  def google_map(center, width, height, zoom)
    image_tag "https://maps.googleapis.com/maps/api/staticmap?center=#{center}&size=#{width}x#{height}&zoom=#{zoom}", :alt => "Mapa"
	end

	def private_or_empty(o,field)
		returned_value = ""
		if o.respond_to?(:fields_visibility)
			ofv = o.fields_visibility
			unless ofv.blank?
				if field.is_a?(Array)
					field.each do |f|
						returned_value += get_field_value(o,f,ofv)
					end
				else
					returned_value = get_field_value(o,field,ofv)
				end
				returned_value.strip!
			else
				returned_value = I18n.t(:private)
			end
		else
			if field.is_a?(Array)
				field.each do |f|
					returned_value += get_field_value(o,f)
				end
			else
				 returned_value = get_field_value(o,field)
			end
			returned_value.strip!
		end
		returned_value
	end

	def get_field_value(o,f,ofv=nil)
		value = nil
		if o.respond_to?(f)
			if ofv.blank? || ofv.has_key?(f)
				value = o.send(f).blank? ? '--' : o.send(f)
			else
				value = I18n.t(:private)
			end
		end
		"#{value} "
	end

	#**helpers para vistas por tipo de instrumento, acuerdo/proyecto y beneficiarios
	def titulo_instrumento
		@tipo_instrumento.present? ? "<b>#{@tipo_instrumento.nombre}</b> <br>" : ""
	end

	def titulo_proyecto
		@proyecto.present? ? "<b>Proyecto: </b> #{@proyecto.flujo.nombre_instrumento} <br><b>Código</b> #{@proyecto.codigo} <br>" : ""
	end

	def titulo_acuerdo
		@manifestacion_de_interes.present? ? "<b>Acuerdo: </b> #{@manifestacion_de_interes.flujo.nombre_instrumento} <br>" : ""
	end

	def titulo_programa
		@ppp.present? ? "<b>Programa: </b> #{@ppp.flujo.nombre_instrumento} <br>" : ""
	end

	def datos_beneficiario
		@flujo.present? ? "<b>Beneficiario: </b> #{@flujo.contribuyente.nombre} <br><b>Rut: </b> #{@flujo.contribuyente.rut}-#{@flujo.contribuyente.dv}" : ""
	end
	#**

	def action_label_of_(model)
		model.new_record? ? 'Crear nueva institución' : 'Editar institución'
	end

	def action_label_representante(model)
		model.new_record? ? 'Crear nuevo representante' : "Editar representante"
	end

	def clase_segun_estado(estado=2)
		clase = 'btn-warning'
		estado_boton = false
		texto_boton = I18n.t(:subir)
		if [2,3].include?(estado)
			clase = estado == 2 ? 'btn-info' : 'btn-success'
			estado_boton = true
			texto_boton = estado == 2 ? I18n.t(:en_revisión) : I18n.t(:aceptada)
		end
		{clase: clase, deshabilitado: estado_boton, texto_boton: texto_boton}
	end

	def volver_root
		link_to t(:back), root_path, class: 'btn btn-warning btn-sm'
	end

	# Genera un árbol con regiones provincias y comunas
	def selector_de_regiones_provincias_comunas(checked={},wrapper=nil)
		capture_haml do
			haml_tag :ul, class: 'rpc-region' do
				Region.rpc[:regiones].each do |rid,region|
					region_name = wrapper.blank? ? "territorios_regiones[#{rid}]" : "#{wrapper}[territorios_regiones[#{rid}]]"
					region_checked = ( !checked.blank?&&checked.has_key?(:territorios_regiones)&&checked[:territorios_regiones].with_indifferent_access.has_key?(rid.to_s) )
					provincia_group_visibility = region_checked ? 'group-show' : 'group-hide'
					haml_tag :li do
						haml_tag :input, class: 'parent-checkbox rpc-checkbox name-region', name: region_name, type: :checkbox, value: region[:nombre], checked: region_checked
						haml_tag :i, class: 'fa fa-chevron-right group-control'
						haml_concat region[:nombre]
						haml_tag :ul, class: "rpc-provincia #{provincia_group_visibility}" do
							region[:provincias].each do |pid,provincia|
								provincia_name = wrapper.blank? ? "territorios_provincias[#{pid}]" : "#{wrapper}[territorios_provincias[#{pid}]]"
								provincia_checked = ( !checked.blank?&&checked.has_key?(:territorios_provincias)&&checked[:territorios_provincias].with_indifferent_access.has_key?(pid.to_s) )
								comuna_group_visibility = provincia_checked ? 'group-show' : 'group-hide'
								haml_tag :li do
									haml_tag :input, class: 'parent-checkbox child-checkbox rpc-checkbox name-provincia', name: provincia_name, type: :checkbox, value: provincia[:nombre], checked: provincia_checked
									haml_tag :i, class: 'fa fa-chevron-right group-control'
									haml_concat provincia[:nombre]
									haml_tag :ul, class: "rpc-comuna #{comuna_group_visibility}" do
										provincia[:comunas].each do |cid,comuna|
											comuna_name = wrapper.blank? ? "territorios_comunas[#{cid}]" : "#{wrapper}[territorios_comunas[#{cid}]]"
											comuna_checked = ( !checked.blank?&&checked.has_key?(:territorios_comunas)&&checked[:territorios_comunas].with_indifferent_access.has_key?(cid.to_s) )
											haml_tag :li do
												haml_tag :input, class: 'child-checkbox rpc-checkbox name-comuna', name: comuna_name, type: :checkbox, value: comuna, checked: comuna_checked
												haml_concat comuna
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	#DZC Helper para el selector de vista TAREA PPF-012
	def selector_de_actividades_economicas(checked={},wrapper=nil)
		capture_haml do
			haml_tag :div, class: 'ae-group' do
				ActividadEconomica.agrupadas.each do |acode,agroup|
					__selector_de_actividades_economicas(agroup,checked,wrapper)
				end
			end
		end
	end

	def __selector_de_actividades_economicas(group,checked={},wrapper=nil, child=0)
		group_id		= group[:id]
		group_text	= group[:nombre]
		group.delete(:id)
		group.delete(:nombre)
		has_children			= ( group.size > 0 )
		group_name 				= wrapper.blank? ? "sectores_economicos[#{group_id}]" : "#{wrapper}[sectores_economicos[#{group_id}]]"
		group_checked			= ( !checked.blank?&&checked.with_indifferent_access.has_key?(group_id.to_s))
		group_visibility	= group_checked ? 'group-show' : 'group-hide'

	   


    haml_tag :div, class: group_name do
      haml_tag :ul do
        haml_tag :li do
        	haml_tag :input, class: (has_children ? 'parent-checkbox child-checkbox' : 'child-checkbox'), name: group_name, type: :checkbox, value: group_text, checked: group_checked
          haml_tag :div, class: 'p-chevron d-inline' do
            haml_tag :i, class: 'fa fa-chevron-right group-control', style: child.blank? ? " " : "padding: 0 0 0 "+child.to_s+"px" if has_children
        		haml_tag :p, group_text, class: 'd-inline', style: has_children ? " " : "padding: 0 0 0 "+child.to_s+"px"
          end
        end  
      end  


  		child = child.blank? ? 25 : child + 25
  		if has_children
  			haml_tag :div, class: "ae-subgroup #{group_visibility}", style: "padding: 0 0 0 0" do
  				group.each do |c,d|
  						#sub_checked = !checked.blank?&&checked.has_key?(c) ? checked[c] : {}
  						__selector_de_actividades_economicas(d,checked,wrapper, child)
  				end
  			end
  		end
    end


	end


	def beauty_tree_selector(tree=[], identifier="default", group="default")
		capture_haml do
			haml_tag :input, name: identifier, value: "", type: :hidden
			haml_tag :div, class: "ae-group #{group}" do
				_beauty_tree_selector(tree, identifier, false)
			end
		end
	end

	def _beauty_tree_selector(tree=[], identifier="default", hidden=true, level=0)
		haml_tag :div, class: (hidden ? 'ml-0 d-none' : 'ml-0') do
			haml_tag :ul, class: 'pl-0' do
				tree.each do |child|
					haml_tag :li, class: (level==0 ? 'ml-2 my-1' : 'my-1') do
						#solo los hijos tienen name, ya que con ellos hacemos la trazabilidad hacia padres
						nombre = identifier if child[:children].blank?
						haml_tag :input, class: "tree-parent d-inline", name: nombre, type: :checkbox, value: child[:id], checked: child[:status] == 'checked', "data-indeterminate" => (child[:status] == 'indeterminate').to_s
						haml_tag :i, class: 'fa fa-chevron-right tree-parent-icon d-inline', style: "cursor: pointer; padding-left: #{level}0px;" unless child[:children].blank?
						haml_tag :label, class: ' d-inline', style: "#{child[:children].blank? ? "margin-left: #{(level*10)+10}px;" : ''}", title: child[:tooltip].blank? ? nil : "Código CIIUV2: #{child[:tooltip]}".html_safe do
							haml_concat child[:name]
							unless child[:data].blank?
								child[:data].each do |key, value|
									haml_tag :div, class: "d-none #{key}" do
										haml_concat value
									end
								end
							end
						end
						_beauty_tree_selector(child[:children], identifier, true, level+1) unless child[:children].blank?
					end
				end
			end
		end
	end

	def __mostrar_(titulo,con_nombre_proyecto)
		"#{titulo}<small>#{con_nombre_proyecto.downcase.gsub(/(apl|acuerdo de producción limpia|acuerdo de produccion limpia)/,'APL').capitalize.gsub(/Apl|apl/,'APL')}</small>".html_safe
	end

	def __mostrar_descargable(descargables,codigo,titulo=nil,tarea_pendiente:nil, carta_interes: nil, nombre:nil)
		capture_haml do
			if descargables.blank? || ! descargables.has_key?(codigo)
				haml_tag :label, '&nbsp;'.html_safe, class: 'control-label'
					haml_tag :div, class: 'form-control p-0' do
						haml_tag :a, href: '#', class: 'btn btn-sm btn-outline-light btn-block tooltip-block ', "data-original-title" => I18n.t(:descargable_no_encontrado) do
							haml_tag :i, class: 'fa fa-ban text-secondary'
						end
					end
				# haml_tag :label, I18n.t(:descargable_no_encontrado), class: 'control-label string text-danger'
				# haml_tag :div, codigo, class: 'form-control'
			else

				if tarea_pendiente.present?
					url = ext_descargable_tarea_url(*descargables[codigo][:args], tarea_pendiente: tarea_pendiente)
				else
					url = ext_descargable_tarea_url(*descargables[codigo][:args])
				end
				if carta_interes.blank?
					id_descarga = 'mostrar_descargable_id'
					boton_label = I18n.t(:descargar)
				else
					id_descarga = 'manifestacion_de_interes_' + carta_interes
					boton_label = nombre.blank? ? carta_interes : nombre
				end
				haml_tag :label, titulo.blank? ? descargables[codigo][:nombre] : titulo, class: 'control-label string' if carta_interes.blank?
				haml_tag :a, href: url, class: 'btn btn-sm btn-outline-secondary btn-block', id: id_descarga do
					haml_tag :i, class: 'fa fa-download'
					haml_concat boton_label
				end
			end
		end
	end

	# DZC 2018-10-26 10:23:18 modifica el método para que, tratándose de un atributo que contenga múltiples archivos, se permita la descarga de un archivo ZIP que contenga todos esos  archivos
	def __descargar_archivo(field,objeto, label = true)
		capture_haml do
			haml_tag :div, class: 'form-group' do
				if label
					haml_tag :label, '&nbsp;'.html_safe, class: 'control-label'
				end
				haml_tag :div, class: "form-control p-0 button-height" do
					#
					if field.present?
						if field.class == Array
							#
							archivos = []
							field.each do |archivo|
								split = archivo.current_path.split('/')# DZC genera un array de palabras dentro del path
								archivos << split[split.length-1] # DZC obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier, y lo agrega al arreglo
							end
							# DZC 2018-10-26 10:24:34 ejecuta el path descarga_zip en aplication_controller, pasando los parámetros nombre de la clase, id del objeto, nombre del atributo
					   	haml_tag :a, href: desacarga_zip_path(clase: objeto.class.name, objeto_id: objeto.id, atributo: field[0].mounted_as), class: 'btn btn-sm btn-outline-light btn-block tooltip-block', download: '', title: archivos.to_sentence, "data-original-title" => archivos.to_sentence do
					   		haml_tag :i, class: 'fa fa-download text-success'
					   	end
						else
							#
							file_name = field.file.filename
							haml_tag :a, href: field.url, class: 'btn btn-sm btn-outline-light btn-block tooltip-block', download: '', title: file_name, "data-original-title" => file_name do
								haml_tag :i, class: 'fa fa-download text-success'
							end
						end
					else
						haml_tag :a, class: 'btn btn-sm btn-outline-light btn-block tooltip-block', "data-original-title" => "Archivo(s) no subido(s)..." do
							haml_tag :i, class: 'fa fa-ban text-secondary'
						end
					end
				end
			end
		end
	end

	def __upload_status(o,field)
		#
		error = o.errors.has_key?(field)
		here_there_a_file = ! o.send(field).blank?
		capture_haml do
			haml_tag :div, class: 'form-group' do
				haml_tag :label, '&nbsp;'.html_safe, class: 'control-label'
				haml_tag :div, class: "form-control border-left-0 text-right#{error ? ' border-error' : nil}" do
					if here_there_a_file
						# DZC 2018-10-25 15:16:08 se modifica para contemplar multiples archivos
						if o.send(field).class == Array
							#
							file_name = []
							o.send(field).each do |archivo|
								file_name << archivo.file.filename
							end
					   	#
						else
							#
							file_name = [o.send(field).file.filename]
						end
						haml_tag :i, class: "tooltip-block fa fa-check-circle fa-1-4x text-#{error ? 'danger' : 'success'}", title: file_name.to_sentence, "data-original-title" => file_name
					else
						haml_tag :i, class: "fa fa-upload fa-1-4x text-#{error ? 'danger' : 'secondary'}"
					end
				end
			end
		end
	end

	def __archivos_status(o,field)
		error = o.errors.has_key?(field)
		here_there_a_file = ! o.send(field).blank?
		capture_haml do
			haml_tag :div, class: 'form-group' do
				haml_tag :label, '&nbsp;'.html_safe, class: 'control-label'
				haml_tag :div, class: "form-control border-left-0 text-right#{error ? ' border-error' : nil}" do
					if here_there_a_file
						file_name = []
						o.send(field).each do |archivo|
							file_name << archivo.file.filename
						end
						haml_tag :i, class: "tooltip-block fa fa-check-circle fa-1-4x text-#{error ? 'danger' : 'success'}", title: file_name.to_sentence, "data-original-title" => file_name.to_sentence
					else
						haml_tag :i, class: "fa fa-upload fa-1-4x text-#{error ? 'danger' : 'secondary'}"
					end
				end
			end
		end
	end

	def field_with_errors?(o,f)
		o.errors.size > 0 && o.errors.messages.size > 0 && o.errors.messages.has_key?(f) && o.errors.messages[f].size > 0
	end

	# DZC 2018-11-05 14:37:46 se descomenta para uso por helper de Ricardo
	def generar_zip archivos
    require 'zip'
    file = Zip::OutputStream.write_buffer do |stream|
      archivos.each_with_index do |archivo_tecnica|
        split = archivo_tecnica.current_path.split('/')
        nombre = split[split.length-1]
        # rename the file
        stream.put_next_entry(nombre)
        # add file to zip
        stream.write IO.read(archivo_tecnica.current_path)
      end
    end
    file.rewind
    file.sysread
  end

  def descarga_formato_carta_de_patrocinio()
  	
  end
end
