class ApplicationRecord < ActiveRecord::Base
  include Hashid::Rails if Rails.env.production?
  self.abstract_class = true
  scope :mientras_no_sea_, ->(columna,valor) { where("#{columna} != (?)", valor) if ( self.respond_to?(columna) && valor.present? )  }

  # DZC 2019-07-11 17:50:06 generaliza la validación de tamaños minimos y maximos de caracteres en campos de texto, desde valores en tabla TooltipsTamano
  def valida_largo_campos
    filtro_tarea = self.tarea_id.present? ? {tarea_id: self.tarea_id} : {}
    #campos = Campo.where(clase: self.class.name, validaciones_activas: true) # DZC 2019-07-30 se modifica para disociar validaciones_activas de campo obligatorio
    campos = Campo.where(clase: self.class.name)
    campos = filtro_tarea.present? ? campos.select{|v| v.tareas.where(filtro_tarea)} : campos
    campos_no_atributos_pero_validables = ["actividad_economicas_ids","comunas_ids","cuencas_ids"]
    campos_con_dependencia = ["estandar_certificable","estandar_de_certificacion_id","diagnostico_de_acuerdo_anterior","diagnostico_id","informe_de_acuerdo_anterior","acuerdo_previo_con_informe_id",
                              "comunas_ids","cuencas_ids"]
    campos.each do |c|
      #min = c[:validacion_min]
      #max = c[:validacion_max]
      if self.attributes.keys.include?(c.atributo.to_s) || campos_no_atributos_pero_validables.include?(c.atributo.to_s) # DZC 2019-07-26 15:06:34 se agrega para evitar error de ejecución de método sobre objeto nulo, con motivo de campos nuevos agregados en tabla 'campos'.
        if c.tipo == "boolean"
          errors.add(c.atributo.to_sym, c.validacion_vacio_mensaje.to_s) if self[c.atributo.to_sym].nil? && c.validacion_contenido_obligatorio
        else
          if (self.send(c.atributo.to_s).blank? || (self.send(c.atributo.to_s).class == Array && self.send(c.atributo.to_s).length < 2)) && c.validacion_contenido_obligatorio
            #revisar dependencias campos
            if(campos_con_dependencia.include?(c.atributo.to_s))
              if ((self.radio_estandar.to_i == 3 && (c.atributo.to_s == "estandar_certificable" || c.atributo.to_s == "estandar_de_certificacion_id")) || (self.radio_estandar.to_i == 0 && c.atributo.to_s == "estandar_certificable") || (self.radio_estandar.to_i == 1 && c.atributo.to_s == "estandar_de_certificacion_id"))
                #7.1 y #7.2
                errors.add(c.atributo.to_sym, c.validacion_vacio_mensaje.to_s)
              elsif ((self.radio_diagnostico.to_i == 3 && (c.atributo.to_s == "diagnostico_de_acuerdo_anterior" || c.atributo.to_s == "diagnostico_id")) || (self.radio_diagnostico.to_i == 0 && c.atributo.to_s == "diagnostico_de_acuerdo_anterior") || (self.radio_diagnostico.to_i == 1 && c.atributo.to_s == "diagnostico_id"))
                #8.1 y 8.2
                errors.add(c.atributo.to_sym, c.validacion_vacio_mensaje.to_s)
              elsif ((self.radio_informe.to_i == 3 && (c.atributo.to_s == "informe_de_acuerdo_anterior" || c.atributo.to_s == "acuerdo_previo_con_informe_id")) || (self.radio_informe.to_i == 0 && c.atributo.to_s == "informe_de_acuerdo_anterior") || (self.radio_informe.to_i == 1 && c.atributo.to_s == "acuerdo_previo_con_informe_id"))
                #8.1 y 8.2
                errors.add(c.atributo.to_sym, c.validacion_vacio_mensaje.to_s)
              elsif (self.acuerdo_de_alcance_nacional == false && (c.atributo.to_s == "comunas_ids" || c.atributo.to_s == "cuencas_ids"))
                #8.3 y #8.4, valido directamente que sea false, porque directo, si esta blanco tambien es false, y no me sirve
                errors.add(c.atributo.to_sym, c.validacion_vacio_mensaje.to_s)
              end
            else
              errors.add(c.atributo.to_sym, c.validacion_vacio_mensaje.to_s)
            end
          elsif c.validaciones_activas.present? && c.validaciones_activas
            min = c[:validacion_min]
            max = c[:validacion_max]
            unless self[c.atributo.to_sym].blank?
              case c.tipo
                when "text"
                  if c.validacion_min_activa && (self.send(c.atributo.to_s).gsub(/\n/, '').length < min)
                    errors.add(c.atributo.to_sym, "El texto ingresado no debe ser menor a #{min} caracteres")
                  end
                  if c.validacion_max_activa && (self.send(c.atributo.to_s).gsub(/\n/, '').length > max)
                    errors.add(c.atributo.to_sym, "El texto ingresado no debe ser mayor a #{max} caracteres")
                  end
                when "integer", "double"
                  if c.validacion_min_activa && (self.send(c.atributo.to_s).to_d < min)
                    errors.add(c.atributo.to_sym, "El número ingresado no debe ser menor a #{min}")
                  end
                  if c.validacion_max_activa && (self.send(c.atributo.to_s).to_d > max)
                    errors.add(c.atributo.to_sym, "El número ingresado no debe ser mayor a #{max}")
                  end
              end
            end
          end
        end
      end
    end
  end

  # DZC 2019-07-17 16:12:54 devuelve las validaciones de los campos asociados a la clase
  # DZC 2019-08-09 se modifica para considerar en una sola consulta todos los valores relevantes de la tabla campos
  def get_campos_validaciones
    filtro_tarea = self.tarea_id.present? ? {tarea_id: self.tarea_id} : {}
    validaciones = {}
    campos = Campo.where(clase: self.class.name) #, validaciones_activas: true, tipo: "text")
    campos = filtro_tarea.present? ? campos.select{|v| v.tareas.where(filtro_tarea)} : campos
    campos.each do |c|
      clase_nombre = c.clase.to_s.constantize.table_name.singularize
      validaciones[clase_nombre.to_sym] = {} if validaciones[clase_nombre.to_sym].blank?
      validaciones[clase_nombre.to_sym][c.atributo.to_sym] = {
        id_campo: c.id,
        nombre: (c.nombre.present? ? c.nombre : c.atributo),
        tooltip_activo: c.tooltip_activo,
        tooltip: (c.tooltip.present? ? c.tooltip : c.atributo),
        ayuda_activo: c.ayuda_activo,
        ayuda: c.ayuda.present? ? c.ayuda : "",
        validaciones_activas: c.validaciones_activas,
        obligatorio_campo: c.validacion_contenido_obligatorio,
        tipo: c.tipo,
        atributo: c.atributo
      }
      if c.validaciones_activas
        validacion_min = c.validacion_min.present? ? c.validacion_min : 0
        validacion_max = c.validacion_max.present? ? c.validacion_max : 0
        validaciones[clase_nombre.to_sym][c.atributo.to_sym].merge!(
          validacion_min_activa: (c.validacion_min_activa.present? & validacion_min != 0) ? c.validacion_min_activa : false,
          validacion_max_activa: (c.validacion_max_activa.present? & validacion_max != 0) ? c.validacion_max_activa : false,
          validacion_min: validacion_min,
          validacion_max: validacion_max
        )
      end
    end
    validaciones
  end

  # DZC 2019-07-17 16:25:50 devuelve los nombres, tooltips y ayudas de los campos asociados a la clase
  def get_campos_textos
    filtro_tarea = self.tarea_id.present? ? {tarea_id: self.tarea_id} : {}
    textos = {}
    campos = Campo.where(clase: self.class.name)
    campos = filtro_tarea.present? ? campos.select{|v| v.tareas.where(filtro_tarea)} : campos
    campos.each do |c|
      clase_nombre = c.clase.to_s.constantize.table_name.singularize
      textos[clase_nombre.to_sym] = {} if textos[clase_nombre.to_sym].blank?
      textos[clase_nombre.to_sym][c.atributo.to_sym] = {
        nombre: (c.nombre.present? ? c.nombre : c.atributo),
        tooltip: (c.tooltip.present? ? c.tooltip : c.atributo),
        ayuda_activo: c.ayuda_activo,
        ayuda: (c.ayuda.present? ? c.ayuda : c.atributo),
        id_campo: c.id
      }
    end
    textos
  end

  # DZC 2019-07-17 18:17:51 devuelve el nombre del atributo, si existe
  def get_campo_label(campo)
    atributo = Campo.where(clase: self.class.name, atributo: campo.to_s).first
    atributo.present? ? (atributo.nombre.present? ? atributo.nombre : campo.to_s) : campo.to_s
  end

  # DZC 2019-07-17 18:17:51 devuelve el tooltip del atributo, si existe
  def get_campo_tooltip(campo)
    atributo = Campo.where(clase: self.class.name, atributo: campo.to_s).first
    atributo.present? ? (atributo.tooltip.present? ? atributo.tooltip : campo.to_s) : campo.to_s
  end

  def __attr_fields
    self.class.instance_methods(false).map(&:to_s).keep_if{|a| a.include?('=')}.map{|a| a.sub('=', '').to_sym}
  end

  def self.agrupar(data,attribute,pname,key=:name,object=false,include_parent=true)
    g = {}
    data.each do |f|
      f_has_nombre = f.respond_to?(:nombre)
      ti = (object) ? f : (f_has_nombre ? [f.nombre, f.id] : [f.send(key), f.id])
      pid = f.send(attribute)
      if pid.nil?
        pkey = ((key == :id) ? f.id : (f_has_nombre ? f.nombre : f.send(key)))
      else
        pobj = f.send(pname)
        pkey = ((key == :id) ? pid : pobj.nombre)
      end

      if ! g.has_key?(pkey)
        g[pkey] = []
      end

      if pkey == ((key == :id) ? f.id : (f_has_nombre ? f.nombre : f.send(key)))
        g[pkey] << ti if include_parent==true
      else
        g[pkey] << ti
      end

      g[pkey] = g[pkey].sort_by{|v,k|k}
    end
    g
  end

  def self.agrupar_con_modelo(data,attribute,pname,key=:name,object=false,include_parent=true)
    g = {}
    data.each do |f|
      f_has_nombre = f.respond_to?(:nombre)
      ti = (object) ? f : (f_has_nombre ? [f.nombre, "TipoInstrumento:#{f.id}"] : [f.send(key), "TipoInstrumento:#{f.id}"])
      pid = f.send(attribute)
      if pid.nil?
        pkey = ((key == :id) ? "TipoInstrumento:#{f.id}" : (f_has_nombre ? f.nombre : f.send(key)))
      else
        pobj = f.send(pname)
        pkey = ((key == :id) ? pid : pobj.nombre)
      end

      if ! g.has_key?(pkey)
        g[pkey] = []
      end

      if pkey == ((key == :id) ? "TipoInstrumento:#{f.id}" : (f_has_nombre ? f.nombre : f.send(key)))
        g[pkey] << ti if include_parent==true
      else
        g[pkey] << ti
      end

      g[pkey] = g[pkey].sort_by{|v,k|k}
    end
    g
  end

  # metodo que genera un arreglo para ser usado en un select recibe 3 valores
  # el valor nombre: puede ser el nombre del campo o un campo de referencia de un objeto pe: (user.nombre),
  # por defecto buscara el campo nombre si no se señala, la recursividad hacia otros objetos no tiene limites
  # el valor id: puede ser el id del campo o un campo de referencia de un objeto pe: (user.id)
  # por defecto buscara el campo id si no se señala, la recursividad hacia otros objetos no tiene limites
  # el valor data: son los registros con los que se desea trabajar, por defecto son todos los registros de la clase,
  # pudiendo recibirlos filtrados tambien
  # si no encuentra los valores :name y/o :id en el objeto de referencia, devolverá un valor anunciando la falla en los parametros
  # si la tabla no contiene datos, devolverá un valor anunciando que no hay registros
  ### se recomienda que la data traiga los include para no realizar tantas consultas a bd, cuando se hagan consultas recursivas
  def self.to_select(name=:nombre,id=:id,data=self.all)
    rec_name = name.to_s.split(".")
    rec_id = id.to_s.split(".")
    ejecucion_incorrecta = false
    select_to = []
    data.each do |da|
      object_test = da
      rec_name.each do |rec|
        object_test = object_test.respond_to?(rec) ? object_test.send(rec) : :error_parametros
      end
      texto = object_test
      object_test = da
      rec_id.each do |rec|
        object_test = object_test.respond_to?(rec) ? object_test.send(rec) : :error_parametros
      end
      valor = object_test
      if (texto == :error_parametros || valor == :error_parametros)
        ejecucion_incorrecta = true
      end
      select_to << [texto,valor]
    end
    salida = ejecucion_incorrecta ? [["Revise parametros: 'name' y/o 'id'",nil]] : nil
    data.blank? ? [["Tabla #{self.name.titleize} sin valores",nil]] : (salida.blank? ? select_to.uniq : salida)
  end

  def self.replace_values(replace,string)
    unless replace.blank? || ! replace.is_a?(Hash)
      rkeys = replace.keys.map{|m|m.to_s}
      string.split(" ").map{|m|
        value = m.gsub(/[^a-z\_\[\]]/,'')
        if rkeys.include?(value)
           m[value]=replace[value.to_sym]
           m
        else
          m
        end
      }.join(" ")
    else
      string
    end
  end

  after_find :load_data_to_attributes
  before_update :load_attributes_to_data

  #DZC Verifica si el plazo se encuentra vigente, se incluye aqui para ser usado desde cualquier instancia de modelo
  def plazo_vigente? fecha_a_validar, dias=25
    plazo = true
      if !fecha_a_validar.nil? #considera que el campo fecha no se haya llenado, por la preexistencia de  datos en la tabla al momento de agregarse el campo de la fecha a validar
        if ((fecha_a_validar.beginning_of_day.to_time.to_i - dias.days.ago.beginning_of_day.to_i) < 0)
          plazo=false
        end
      end
    plazo
  end

  #DZC Evita el ingreso e fechas anteriores a la actual
  def fecha_es_anterior? fecha
    es_anterior=false
    if fecha.beginning_of_day.to_time.to_i < Time.now.beginning_of_day.to_i
      es_anterior=true
    end
    es_anterior
  end

  def obliga_fecha fecha
    fecha_es_anterior? fecha ? fecha=Time.now.beginning_of_day : fecha.to_time
  end

  # DZC 2018-10-25 19:33:41 método para generar archivo zip desde un atributo con multiples archivos
  def genera_zip(atributo)
    archivos = atributo
    archivos = [archivos] if !archivos.is_a?(Array)
    require 'zip'
    archivo_zip = Zip::OutputStream.write_buffer do |stream|
      archivos.each do |archivo|
        if archivo.is_a?(String)
          archivo_path = "#{Rails.root}/public#{archivo}"
          if File.exists?(archivo_path)
            split = archivo_path.split('/')
            nombre = split[split.length-1] # obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier
            # rename the file
            stream.put_next_entry(nombre)
            # add file to zip
            stream.write IO.read(archivo_path)
          end
        else
          if File.exists?(archivo.path)
            split = archivo.current_path.split('/') rescue archivo.path.split('/')# genera un array de palabras dentro del path
            nombre = split[split.length-1] # obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier
            # rename the file
            stream.put_next_entry(nombre)
            # add file to zip
            stream.write IO.read((archivo.current_path rescue archivo.path))
          end
        end
      end
    end
    archivo_zip.rewind
    archivo_zip.sysread
  end

  protected

  def load_data_to_attributes
    if self.respond_to?(:data) && self.data.is_a?(Hash)
      self.data.each do |attr,value|
        if self.respond_to?(attr)
          self.send("#{attr}=",value)
        end
      end
    end
  end

  def load_attributes_to_data
    if self.respond_to?(:data)
      __attr_fields.sort.each do |attr|
        if self.respond_to?(attr)
          unless self.send(attr).blank? || self.send(attr) == self.data[attr]
            self.data[attr] = self.send(attr)
          end
        end
      end
    end
  end

  def get_currency_format_of(number)
    ActionController::Base.helpers.number_to_currency(number)
  end

  #Ricardo: Scope que permite verificar si el campo presente un campo valido.
  scope :vigente?, -> { where(vigente: true) }
end
