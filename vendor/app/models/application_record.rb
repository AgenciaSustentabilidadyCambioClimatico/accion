class ApplicationRecord < ActiveRecord::Base
  include Hashid::Rails if Rails.env.production?
  self.abstract_class = true
  scope :mientras_no_sea_, ->(columna,valor) { where("#{columna} != (?)", valor) if ( self.respond_to?(columna) && valor.present? )  }

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
        if File.exists?(archivo.path)
          split = archivo.current_path.split('/') # genera un array de palabras dentro del path
          nombre = split[split.length-1] # obtiene el nombre del archivo separandolo del ultimo '/', en subsidio se puede usar .identifier
          # rename the file
          stream.put_next_entry(nombre)
          # add file to zip
          stream.write IO.read(archivo.current_path)
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