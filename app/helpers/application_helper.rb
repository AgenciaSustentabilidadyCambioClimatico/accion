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

  ##FPL##
  def titulo_instrumento_fpl
    @tipo_instrumento.present? ? "<b>#{TipoInstrumento::STR_FONDO_DE_PRODUCCION_LIMPIA}</b> <br>" : ""
  end

  def titulo_apl
    @manifestacion_de_interes.present? ? "<b>APL: </b> #{@manifestacion_de_interes.flujo.nombre_instrumento} <br>" : ""
  end

  def titulo_proyecto_fpl
    @fondo_produccion_limpia.present? ? "<b>Proyecto: </b> #{@fondo_produccion_limpia.codigo_proyecto} <br>" : ""
  end

  def datos_beneficiario_fpl
    if @fondo_produccion_limpia.institucion_entregables_id.present?
      @flujo.present? ? "<b>Beneficiario: </b> #{obtiene_contribuyente(@fondo_produccion_limpia.institucion_entregables_id).razon_social} <br><b>Rut: </b> #{obtiene_contribuyente(@fondo_produccion_limpia.institucion_entregables_id).rut}-#{obtiene_contribuyente(@fondo_produccion_limpia.institucion_entregables_id).dv}" : ""
    else
      @flujo.present? ? "<b>Beneficiario: </b> #{@manifestacion_de_interes.institucion_gestora_acuerdo} <br><b>Rut: </b> #{@manifestacion_de_interes.rut_institucion_gestora_acuerdo}" : ""
    end
  end
  #**

  def action_label_of_(model,use_model_name=false)
    # AON: debería ser algo así, pero habria que traducir todos los modelos en cuestion
    if use_model_name
      prefijo = model.new_record? ? "Crear" : "Editar"
      nombre_clase = I18n.t(model.class.name).downcase
      # retornamos el nombre
      return "#{prefijo} #{nombre_clase}"
    else
      model.new_record? ? 'Crear nueva institución' : 'Editar institución'
    end
  end

  def action_label_representante(model)
    model.new_record? ? 'Crear nuevo representante' : "Editar representante"
  end

  def action_label_objetivo(model)
    model.new_record? ? 'Crear nuevo objetivo' : "Editar objetivo"
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
    group_id        = group[:id]
    group_text  = group[:nombre]
    group.delete(:id)
    group.delete(:nombre)
    has_children            = ( group.size > 0 )
    group_name              = wrapper.blank? ? "sectores_economicos[#{group_id}]" : "#{wrapper}[sectores_economicos[#{group_id}]]"
    group_checked           = ( !checked.blank?&&checked.with_indifferent_access.has_key?(group_id.to_s))
    group_visibility    = group_checked ? 'group-show' : 'group-hide'

     


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
      haml_tag :div do
        haml_tag :input, type: :string, placeholder: "Buscar ...", class: "w-100 search"
      end
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

  def __mostrar_descargable(descargables, codigo, titulo = nil, tarea_pendiente = nil, carta_interes = nil, nombre = nil, nombre_boton ='')
    capture_haml do
      if carta_interes.blank?
        id_descarga = 'mostrar_descargable_id'
        boton_label = nombre_boton.blank? ? I18n.t(:descargar) : nombre_boton
      else
        id_descarga = 'manifestacion_de_interes_' + carta_interes
        boton_label = nombre.blank? ? carta_interes : nombre
      end

      if descargables.blank? || !descargables.key?(codigo)
        haml_tag :label, nombre, class: 'control-label string pt-06' if carta_interes.blank?
        haml_tag :a, href: '#', class: 'btn btn-sm btn-descargar btn-block tooltip-block ', "data-original-title" => I18n.t(:descargable_no_encontrado), id: id_descarga do
          haml_tag :i, class: 'fa fa-ban'
        end
        # haml_tag :label, I18n.t(:descargable_no_encontrado), class: 'control-label string text-danger'
        # haml_tag :div, codigo, class: 'form-control'
      else

        if tarea_pendiente.present?
          url = ext_descargable_tarea_url(*[tarea_pendiente]+descargables[codigo][:args])
        else
          url = ext_descargable_tarea_url(*descargables[codigo][:args])
        end
        haml_tag :label, titulo.blank? ? descargables[codigo][:nombre] : titulo, class: 'control-label string' if carta_interes.blank?
        haml_tag :a, href: url, class: 'btn btn-sm btn-descargar btn-block', id: id_descarga do
          haml_tag :i, class: 'fa fa-download'
          haml_concat boton_label
        end
      end
    end
  end
  def __mostrar_descargable_simple(tarea,codigo,titulo, boton=I18n.t(:descargar))
    descargable = tarea.descargable_tareas.find_by(codigo: codigo)
    capture_haml do
      if descargable.blank?
        haml_tag :div, class: 'form-group' do 
          haml_tag :label, titulo, class: 'control-label string'
          haml_tag :a, href: '#', class: 'btn btn-sm btn-descargar btn-block tooltip-block ', "data-original-title" => I18n.t(:descargable_no_encontrado) do
            haml_tag :i, class: 'fa fa-ban'
          end
        end
        # haml_tag :label, I18n.t(:descargable_no_encontrado), class: 'control-label string text-danger'
        # haml_tag :div, codigo, class: 'form-control'
      else
        haml_tag :div, class: 'form-group' do 
          haml_tag :label, titulo.blank? ? descargable.nombre : titulo, class: 'control-label string'
          haml_tag :a, href: descargar_admin_tarea_descargable_tarea_path(tarea, descargable), class: 'btn btn-sm btn-descargar btn-block' do
            haml_tag :i, class: 'fa fa-download'
            haml_concat boton
          end
        end
      end
    end
  end
  def __mostrar_descargable_simple_2(tarea,codigo,titulo, boton=I18n.t(:descargar))
    descargable = tarea.descargable_tareas.find_by(codigo: codigo)
    capture_haml do
      if descargable.blank?
        haml_tag :div, class: 'form-group' do 
          haml_tag :label, titulo, class: 'control-label string'
          haml_tag :a, href: '#', class: 'btn btn-sm btn-descargar btn-block tooltip-block ', "data-original-title" => I18n.t(:descargable_no_encontrado) do
            haml_tag :i, class: 'fa fa-ban'
          end
        end
        # haml_tag :label, I18n.t(:descargable_no_encontrado), class: 'control-label string text-danger'
        # haml_tag :div, codigo, class: 'form-control'
      else
        haml_tag :div, class: 'form-group' do 
          haml_tag :a, href: descargar_admin_tarea_descargable_tarea_path(tarea, descargable), class: 'btn btn-sm btn-descargar btn-block' do
            haml_tag :i, class: 'fa fa-download'
            haml_concat boton
          end
        end
      end
    end
  end

  def __mostrar_descargable_sin_titulo(tarea,codigo)
    descargable = tarea.descargable_tareas.find_by(codigo: codigo)
    capture_haml do
      if descargable.blank?
        haml_tag :div, class: 'form-group' do 
          haml_tag :a, href: '#', class: 'btn btn-sm btn-descargar btn-block tooltip-block ', "data-original-title" => I18n.t(:descargable_no_encontrado) do
            haml_tag :i, class: 'fa fa-ban'
          end
        end
      else
        haml_tag :div, class: 'form-group' do 
          haml_tag :a, href: descargar_admin_tarea_descargable_tarea_path(tarea, descargable), class: 'btn btn-sm btn-descargar btn-block' do
            haml_tag :i, class: 'fa fa-download', style: 'color: #007bff;'

          end
        end
      end
    end
  end

  # DZC 2018-10-26 10:23:18 modifica el método para que, tratándose de un atributo que contenga múltiples archivos, se permita la descarga de un archivo ZIP que contenga todos esos  archivos
  def __descargar_archivo(field,objeto, label = true, nombre_boton=true, titulo=nil, boton=nil, from_proveedor=false, from_historial=false)
    capture_haml do
      haml_tag :div, class: 'form-group' do
        haml_tag :label, (titulo.blank? ? '&nbsp;'.html_safe : titulo), class: 'control-label' if label
        if field.present?
          padding = 'px-5'
          padding = '' if nombre_boton.blank?
          if field.class == Array
            #
            archivos = []
            atributo = []
            field.each do |archivo|
              split = archivo.current_path.split('/') rescue archivo.path.split('/')# DZC genera un array de palabras dentro del path
              archivos << split[split.length-1] # DZC obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier, y lo agrega al arreglo
              atributo << archivo.path.split('/public').last
            end
            begin
              atributo = field[0].mounted_as
            rescue
            end
            # DZC 2018-10-26 10:24:34 ejecuta el path descarga_zip en aplication_controller, pasando los parámetros nombre de la clase, id del objeto, nombre del atributo
            haml_tag :a, href: desacarga_zip_path(clase: objeto.class.name, objeto_id: objeto.id, atributo: atributo), class: 'btn btn-sm btn-descargar btn-block tooltip-block '+padding, download: '', title: archivos.to_sentence, "data-original-title" => archivos.to_sentence do
              haml_tag :i, class: 'fa fa-download'
              haml_concat (boton.blank? ? archivos.to_sentence : boton) if nombre_boton
            end
          else
            #
            begin
              file_name = field.file.filename
              url = field.url
            rescue
              file_split = field.path.split('/public')
              url = request.base_url + file_split.last
              file_name = file_split.last.split('/').last
            end
            haml_tag :a, href: url, class: "#{!from_historial ? (from_proveedor ? '' : 'btn btn-sm btn-descargar btn-block tooltip-block '+padding) : 'btn-tabla-instrumentos' }", download: '', title: file_name, "data-original-title" => file_name do
              haml_tag :i, class: 'fa fa-download'
              haml_concat (boton.blank? ? file_name : boton) if nombre_boton
            end
          end
        else
          haml_tag :a, class: 'btn btn-sm btn-descargar btn-block tooltip-block', "data-original-title" => "Archivo(s) no subido(s)..." do
            haml_tag :i, class: 'fa fa-ban'
          end
        end
      end
    end
  end

  def __descargar_archivo_sin_titulo(field,objeto, label = true, nombre_boton=true, titulo=nil, boton=nil, from_proveedor=false, from_historial=false)
    capture_haml do
      haml_tag :div, class: 'form-group' do
        if field.present?
          padding = 'px-5'
          padding = '' if nombre_boton.blank?
          if field.class == Array
            #
            archivos = []
            atributo = []
            field.each do |archivo|
              split = archivo.current_path.split('/') rescue archivo.path.split('/')# DZC genera un array de palabras dentro del path
              archivos << split[split.length-1] # DZC obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier, y lo agrega al arreglo
              atributo << archivo.path.split('/public').last
            end
            begin
              atributo = field[0].mounted_as
            rescue
            end
            # DZC 2018-10-26 10:24:34 ejecuta el path descarga_zip en aplication_controller, pasando los parámetros nombre de la clase, id del objeto, nombre del atributo
            haml_tag :a, href: desacarga_zip_path(clase: objeto.class.name, objeto_id: objeto.id, atributo: atributo), class: 'btn btn-sm btn-descargar btn-block tooltip-block '+padding, download: '', title: archivos.to_sentence, "data-original-title" => archivos.to_sentence do
              haml_tag :i, class: 'fa fa-download'
              haml_concat (boton.blank? ? archivos.to_sentence : boton) if nombre_boton
            end
          else
            #
            begin
              file_name = field.file.filename
              url = field.url
            rescue
              file_split = field.path.split('/public')
              url = request.base_url + file_split.last
              file_name = file_split.last.split('/').last
            end
            haml_tag :a, href: url, class: "#{!from_historial ? (from_proveedor ? '' : 'btn btn-sm btn-descargar btn-block tooltip-block '+padding) : 'btn-tabla-instrumentos' }", download: '', title: file_name, "data-original-title" => file_name do
              haml_tag :i, class: 'fa fa-download'
              haml_concat (boton.blank? ? file_name : boton) if nombre_boton
            end
          end
        else
          haml_tag :a, class: 'btn btn-sm btn-descargar btn-block tooltip-block', "data-original-title" => "Archivo(s) no subido(s)..." do
            haml_tag :i, class: 'fa fa-ban'
          end
        end
      end
    end
  end

  def __subida_archivo(nombre, objeto, label=true, solo_lectura=false)
    field = objeto.send(nombre)
    filename = "Archivo(s) no subido(s)"
    url = ""
    if field.present?
      if field.class == Array
        archivos = []
        field.each do |archivo|
          split = archivo.current_path.split('/')# DZC genera un array de palabras dentro del path
          archivos << split[split.length-1] # DZC obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier, y lo agrega al arreglo
        end
        filename = archivos.to_sentence
        url = desacarga_zip_path(clase: objeto.class.name, objeto_id: objeto.id, atributo: field[0].mounted_as)
      else
        filename = field.file.filename
        url = field.url
      end
    end
    tiene_error = ''
    tooltip_nombre = {title: filename, "data-original-title" => filename}
    if objeto.errors.messages.has_key?(nombre.to_sym)
      tiene_error = 'has-error'
      tooltip_nombre = {}
    end
    capture_haml do
      haml_tag :div, class: 'form-group '+tiene_error do
        if label
          haml_tag :label, '&nbsp;'.html_safe, class: 'control-label string'
        end
        if !solo_lectura
          haml_tag :input, class: 'd-none file-seleccione-archivo', type: :file, id: objeto.class.to_s.underscore+"_"+nombre, name: objeto.class.to_s.underscore+"["+nombre+"]"
        end
        haml_tag :div, class: 'input-group mb-3' do
          if !solo_lectura
            haml_tag :div, class: 'input-group-prepend' do
              haml_tag :button, "Seleccione Archivo", type: :button, class: 'btn btn-descargar button-seleccione-archivo letter-size', "data-input-file" => objeto.class.to_s.underscore+"_"+nombre
            end
          end
          haml_tag :label, filename, {class: 'form-control texto-cortado label-seleccione-archivo letter-size', disabled: true}.merge(tooltip_nombre)
          if field.present?
            haml_tag :div, class: 'input-group-append' do
              haml_tag :a, href: url, class: 'btn btn-descargar' do
                haml_tag :i, class: 'fa fa-download'
              end
            end
          end
        end
        if objeto.errors.messages.has_key?(nombre.to_sym)
          haml_tag :span, objeto.errors.messages[nombre.to_sym].first, class: "help-block"
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


def generar_zip(archivos)
  require 'open-uri'
  require 'zip'
  file = Zip::OutputStream.write_buffer do |stream|
    archivos.each do |archivo_tecnica|
      if archivo_tecnica.is_a?(Hash)
        # Handle hash entries with in-memory data
        nombre = archivo_tecnica[:nombre]
        stream.put_next_entry(nombre)
        stream.write archivo_tecnica[:data] if archivo_tecnica[:data]
      else
        # Retrieve the S3 URL from CarrierWave uploader
        url = archivo_tecnica.url
        nombre = File.basename(URI.parse(url).path)

        # Open and read the file from S3
        URI.open(url) do |file_data|
          stream.put_next_entry(nombre)
          stream.write file_data.read
        end
      end
    end
  end

  file.rewind
  file.read
end

  def descarga_formato_carta_de_patrocinio()
  
  end

  def clave_unica_btn
  capture_haml do
      haml_tag :a, href: ClaveUnica.url_server_auth, class: 'btn btn-claveunica'
    end
  end

  def url_segun_tarea pendiente, tarea=nil, flujo=nil, encuesta=nil, proyecto=nil 
  tarea = tarea.nil? ? pendiente.tarea : tarea
  flujo = flujo.nil? ? pendiente.flujo : flujo
  encuesta = encuesta.nil? ? tarea.encuesta : encuesta
  proyecto = proyecto.nil? ? pendiente.flujo.proyecto : proyecto
  data = {url:"", icon: "", recognize: ""}
  if pendiente.es_convocatoria?
    data[:url] = tarea_pendiente_convocatorias_path(pendiente)#DZC Común para todas las convocatorias
    data[:icon] = "<i class='fa fa-edit'></i>"
  elsif pendiente.es_minuta? && !pendiente.data.nil? #DZC Común para todas las minutas
    convocatoria = pendiente.determina_convocatoria
    data[:url] = edit_tarea_pendiente_convocatoria_minuta_path(pendiente, convocatoria) if !convocatoria.nil?
    data[:icon] = "<i class='fa fa-edit'></i>"
  elsif tarea.es_una_encuesta && tarea.codigo != Tarea::COD_APL_019#DZC Común para todas las encuestas, salvo APL-019, en teoria la 19 ya no es encuesta, asique no seria necesario agregarla en el if
    if tarea.codigo == Tarea::COD_APL_039 || tarea.codigo == Tarea::COD_APL_043
      #la 39 se habilita solo 1 mes después del plazo cierre de auditoria intermedia
      auditoria = pendiente.determina_auditoria
      informe_acuerdo = flujo.manifestacion_de_interes.informe_acuerdo
      fecha_comparativa = informe_acuerdo.fecha_desde_tipo_acuerdo
      #a fecha comparativa le agrego el plazo total de auditoria y le sumo 1 mes, 
      #porque un mes despues del plazo cierre se habilita encuesta
      if auditoria.final || (!fecha_comparativa.nil? && !auditoria.plazo_cierre.nil? && (fecha_comparativa + auditoria.plazo_cierre.months + 1.months) <= Date.today)
      data[:url] = responder_admin_encuesta_path(pendiente,encuesta)
      data[:icon] = "<i class='fa fa-edit'></i>"
      else
      data[:url] = root_path
      data[:icon] = "<i class='fa fa-exclamation-triangle' data-toggle='tooltip' title='Aún no se habilita plazo para responder encuesta de auditoría intermedia'></i>"
      end
    else
      data[:url] = responder_admin_encuesta_path(pendiente,encuesta)
      data[:icon] = "<i class='fa fa-edit'></i>"
    end
  else
    case tarea.codigo
    when Tarea::COD_APL_001
    data[:url] = manifestacion_de_interes_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_002
    data[:url] = revisor_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_003_1
    data[:url] = admisibilidad_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_003_2
    data[:url] = admisibilidad_juridica_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_004_1
    data[:url] = observaciones_admisibilidad_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_004_2
    data[:url] = observaciones_admisibilidad_juridica_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_005
    data[:url] = pertinencia_factibilidad_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_006
    data[:url] = responder_pertinencia_factibilidad_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_007
    data[:url] = tarea_pendiente_hitos_de_prensa_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_008
    data[:url] = usuario_entregables_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_009
    data[:url] = actualizacion_mapa_de_actores_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_010
    data[:url] = revision_mapa_de_actores_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_013
    data[:url] = cargar_actualizar_entregable_diagnostico_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_014
    data[:url] = revisar_entregable_diagnostico_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_018
    data[:url] = acuerdo_actores_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_019 #DZC Encuesta y Set de metas y acciones
    data[:url] = evaluacion_negociacion_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes, encuesta)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_020
    data[:url] = actualizar_acuerdos_actores_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_021
    data[:url] = actores_convocatorias_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_023
    data[:url] = actualizar_comite_acuerdos_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_024
    data[:url] = usuarios_cargo_entregables_manifestacion_de_interes_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_025
    data[:url] = actualizar_adhesion_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_028
    data[:url] = revisar_adhesion_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_029
    data[:url] = dato_productivo_elemento_adheridos_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_032
    unless false#Adhesion.find_by(flujo_id: flujo.id).adhesiones_aceptadas_mias.blank?
      data[:url] = actualizar_auditorias_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
      data[:icon] = "<i class='fa fa-edit'></i>"
    else
      data[:url] = tarea_pendiente_auditoria_sin_elementos_adheridos_path(pendiente)
      data[:icon] = "<i class='fa fa-exclamation-triangle' data-toggle='tooltip' title='APL sin elementos adheridos'></i>"
      end
    when Tarea::COD_APL_032_1
    unless false#Adhesion.unscoped.where(id: pendiente.data[:adhesion_id]).first.adhesiones_aceptadas_mias.blank?
      data[:url] = actualizar_auditorias_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
      data[:icon] = "<i class='fa fa-edit'></i>"
    else
      data[:url] = tarea_pendiente_auditoria_sin_elementos_adheridos_path(pendiente)
      data[:icon] = "<i class='fa fa-exclamation-triangle' data-toggle='tooltip' title='APL sin elementos adheridos'></i>"
      end
    when Tarea::COD_APL_033
    auditoria = pendiente.determina_auditoria
    informe_acuerdo = flujo.manifestacion_de_interes.informe_acuerdo
    fecha_comparativa = informe_acuerdo.fecha_desde_tipo_acuerdo
    hoy =  DateTime.now
    #hoy debo estan entre os plazos de auditoria, inclusivo
    if (!fecha_comparativa.nil? && !auditoria.plazo_apertura.nil? && !auditoria.plazo_cierre.nil?) && hoy >= (fecha_comparativa + auditoria.plazo_apertura.months) && hoy <= (fecha_comparativa + auditoria.plazo_cierre.months)
      data[:url] = revisar_auditorias_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
      data[:icon] = "<i class='fa fa-edit'></i>"
    else
      data[:url] = root_path
      data[:icon] = "<i class='fa fa-exclamation-triangle' data-toggle='tooltip' title='No se encuentra dentro del plazo para revisar auditoría'></i>"
    end
    when Tarea::COD_APL_034
    data[:url] = validar_auditorias_manifestacion_de_interes_path(pendiente, flujo.manifestacion_de_interes)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_037
    data[:url] = ceremonia_certificaciones_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_040
    data[:url] = usuarios_cargo_informe_manifestacion_de_interes_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_041
    data[:url] = informe_impactos_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_APL_042
    data[:url] = informe_impacto_revisar_manifestacion_de_interes_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_001
    data[:url] = edit_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_002
    data[:url] = asignar_revisor_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_003
    data[:url] = revision_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_004
    data[:url] = resolver_observaciones_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_005
    data[:url] = carta_de_apoyo_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_006
    data[:url] = seguimiento_a_terceros_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_007
    data[:url] = elaboracion_inicial_propuesta_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_008
    data[:url] = observaciones_tecnicas_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_009
    data[:url] = datos_postulacion_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_010
    data[:url] = seguimiento_proyecto_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_011
    data[:url] = asignar_usuarios_a_cargo_ejecucion_programa_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_012
    data[:url] = datos_ejecucion_presupuestaria_anual_ppf_tarea_pendiente_programa_proyecto_propuesta_path(pendiente,pendiente.flujo.ppp)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_013
    data[:url] = ppf_agenda_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_016
    data[:url] = actualizar_adhesion_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_017
    data[:url] = revisar_adhesion_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_018
    data[:url] = ppf_tarea_pendiente_set_metas_acciones_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_019
    data[:url] = revision_ppf_tarea_pendiente_set_metas_acciones_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_020
    data[:url] = dato_productivo_elemento_adheridos_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_021
    data[:url] = ppf_tarea_pendiente_cargar_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PPF_022
    data[:url] = ppf_tarea_pendiente_aprobar_path(pendiente)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_003
    data[:url] = seguimiento_fpl_proyecto_documento_garantias_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-file-text-o'></i>"
    when Tarea::COD_FPL_005
    data[:url] = responsables_seguimiento_fpl_proyecto_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-user-o'></i>"
    when Tarea::COD_FPL_006
    data[:url] = new_seguimiento_fpl_proyecto_reunion_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-comments-o'></i>"
    when Tarea::COD_FPL_007
    data[:url] = calendario_seguimiento_fpl_proyecto_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-calendar-o'></i>"
    when Tarea::COD_FPL_008
    data[:url] = solicitud_pago_seguimiento_fpl_proyecto_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-dollar'></i>"
    when Tarea::COD_FPL_009
    data = pendiente.data
    pago = ProyectoPago.find(data[:pago_id])
    data[:url] = seguimiento_fpl_proyecto_proyecto_pagos_orden_pago_path(pendiente,proyecto, pago)
    data[:icon] = "<i class='fa fa-dollar'></i>"
    when Tarea::COD_FPL_010
    data = pendiente.data
    pago = ProyectoPago.find(data[:pago_id])
    data[:url] = seguimiento_fpl_proyecto_proyecto_pagos_fecha_pago_path(pendiente,proyecto, pago)
    data[:icon] = "<i class='fa fa-calendar-o'></i>"
    when Tarea::COD_FPL_011
    data[:url] = seguimiento_fpl_proyecto_rendicion_actividades_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-file-text-o'></i>"
    when Tarea::COD_FPL_012
    data[:url] = seguimiento_fpl_proyecto_rendicion_actividad_rendicion_tecnica_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-file-text-o'></i>"
    when Tarea::COD_FPL_013
    data[:url] = seguimiento_fpl_proyecto_rendicion_actividad_rendicion_contable_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-file-text-o'></i>"
    when Tarea::COD_FPL_014
    data = pendiente.data
    encuesta = Encuesta.find(data[:encuesta_id])
    data[:url] = responder_admin_encuesta_path(pendiente,encuesta)
    data[:icon] = "<i class='fa fa-file-text-o'></i>"
    when Tarea::COD_FPL_015
    data[:url] = seguimiento_fpl_proyecto_proyecto_actividades_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-calendar-o'></i>"
    when Tarea::COD_FPL_016
    data[:url] = seguimiento_fpl_proyecto_proyecto_actividades_path(pendiente,proyecto)
    data[:icon] = "<i class='fa fa-calendar-o'></i>"
    when Tarea::COD_FPL_017
    data[:url] = resolucion_contrato_seguimiento_fpl_proyecto_path(pendiente, proyecto)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_018
    data[:url] = restitucion_seguimiento_fpl_proyecto_path(pendiente, proyecto)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_002
    data[:url] = registro_proveedores_path
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_003
    data[:url] = revision_registro_proveedores_path
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_004
    user_rut = User.find(pendiente.user_id).rut
    registro_proveedor = RegistroProveedor.where(rut: user_rut).last
    data[:url] = edit_registro_proveedor_path(registro_proveedor.id)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_005
    data[:url] = resultado_revision_path
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_006
    user_rut = User.find(pendiente.user_id).rut
    registro_proveedor = RegistroProveedor.where(rut: user_rut).last
    data[:url] = edit_proveedor_path(registro_proveedor.id)
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_007
    user_rut = User.find(pendiente.user_id).rut
    registro_proveedor = RegistroProveedor.where(rut: user_rut).last
      if registro_proveedor.fecha_aprobado + (2.year + 11.month) <= Date.today && registro_proveedor.fecha_aprobado + 3.year >= Date.today
        data[:url] = actualizar_proveedor_path(registro_proveedor.id)
        data[:icon] = "<i class='fa fa-edit'></i>"
      end
    when Tarea::COD_PRO_008
    data[:url] = resultado_actualizacion_path
    data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_009
      data[:url] = evaluacion_proveedores_path
      data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_PRO_010
      user_rut = User.find(pendiente.user_id).rut
      registro_proveedor = RegistroProveedor.where(rut: user_rut).last
      data[:url] = enviar_carta_compromiso_path(registro_proveedor.id)
      data[:icon] = "<i class='fa fa-edit'></i>"
    ###Nuevo flujo postulacion FPL###
    when Tarea::COD_FPL_00
      data[:url] = usuario_entregables_fondo_produccion_limpias_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_01
      data[:url] = iniciar_flujo_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_02
      data[:url] =  revisor_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_03
      data[:url] =  admisibilidad_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_04
      data[:url] =  admisibilidad_tecnica_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_05
      data[:url] =  admisibilidad_juridica_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"
    when Tarea::COD_FPL_06
      data[:url] =  pertinencia_factibilidad_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"  
    when Tarea::COD_FPL_07
      data[:url] =  observaciones_admisibilidad_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"  
    when Tarea::COD_FPL_08
      data[:url] =  observaciones_admisibilidad_tecnica_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"  
    when Tarea::COD_FPL_09
      data[:url] =  observaciones_admisibilidad_juridica_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"  
    when Tarea::COD_FPL_10
      data[:url] =  evaluacion_general_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"  
    when Tarea::COD_FPL_11
      data[:url] =  resolucion_contrato_fondo_produccion_limpia_path(pendiente)
      data[:icon] = "<i class='fa fa-edit'></i>"  
    #Nuevo flujo postulacion FPL  
    end
  end
  data
  end
  
  def __descargar_archivo_anexo_informe(field)
    capture_haml do
      haml_tag :div, class: 'form-group' do
        if field.present?
          file_name = field.file.basename
          haml_tag :a, href: field.url, class: 'btn-tabla tooltip-block px-3', style: "text-overflow: ellipsis;overflow: hidden;white-space: nowrap;max-width: 100%;", download: '', title: file_name, "data-original-title" => file_name do
            haml_tag :i, class: 'fa fa-download'
            haml_concat file_name
          end
        else
          haml_tag :a, class: 'btn-tabla tooltip-block px-3', "data-original-title" => "Archivo(s) no subido(s)..." do
            haml_tag :i, class: 'fa fa-ban'
          end
        end
      end
    end
  end

  def svg_inline(icon_name, options={})
    file = File.read(Rails.root.join('app', 'assets', 'images', icon_name))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each {|attr, value| svg[attr.to_s] = value}

    doc.to_html.html_safe
  end

  def img64(path,request)
    require 'open-uri'
    base_url = request.base_url
    if Rails.env.production? || Rails.env.staging?
      base_url = request.base_url.gsub(":443","").gsub(":80","")
    end
    url = "#{base_url}#{path}"
    file = open(url)
    if file.blank?
      return ""
    else
      return 'data:image/png;base64,' + Base64.strict_encode64(file.read)
    end
  end

  def format_rut(rut)
    return rut unless rut.present?
  
    # Limpiar el RUT de espacios, puntos y guiones
    rut = rut.to_s.gsub(/[\s.-]/, '').strip
  
    # Asegúrate de que el RUT tenga solo números y un dígito verificador al final
    return rut unless rut =~ /^\d{7,8}[kK0-9]$/ 
  
    # Dividir el RUT en parte numérica y dígito verificador
    rut_numerico = rut[0..-2] # Parte numérica
    dv = rut[-1]               # Dígito verificador
  
    # Formatear el RUT con puntos
    formatted_rut = rut_numerico.reverse.gsub(/(\d{3})(?=\d)/, '\1.').reverse
  
    # Asegurarse de que los puntos estén correctamente colocados
    formatted_rut = formatted_rut.sub(/^(\d{1,2})(\d{3})/, '\1.\2') if formatted_rut.length > 7
  
    "#{formatted_rut}-#{dv.upcase}"
  end
  
  
  
end
