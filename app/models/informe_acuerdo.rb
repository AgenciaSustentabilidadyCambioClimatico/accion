class InformeAcuerdo < ApplicationRecord
  belongs_to :manifestacion_de_interes

  # validates :con_extension, presence: true, unless: -> { self.tarea_codigo == Tarea::COD_APL_018 || self.solo_guarda_archivos}
  validates :plazo_maximo_adhesion, presence: true, unless: -> { self.solo_respuesta_observaciones || self.solo_guarda_archivos }#, on: :update #, unless: -> { (self.plazo_maximo_adhesion.blank? ? (self.plazo_maximo_adhesion = 0) : false }
  validates :plazo_finalizacion_implementacion, presence: true, unless: -> { self.solo_respuesta_observaciones || self.solo_guarda_archivos }
  #validates :plazo_maximo_neto, presence: true#, on: :update
  #validate :plazos_correctos?, on: :update, unless: ->{self.accion.present? && self.accion == "guardar_archivos_anexos_posteriores_firmas"} #DZC 2018-11-15 14:44:46 valida que los plazos contengan la lógica entre ellos, salvo que solo se esté guardando el archivo de evidencia obligatorio
  validates :plazo_vigencia_acuerdo, presence: true, unless: -> { self.solo_respuesta_observaciones || self.solo_guarda_archivos }
  validates :vigencia_certificacion_final, presence: true, unless: -> { self.solo_respuesta_observaciones || self.solo_guarda_archivos }
  validates :tipo_acuerdo, presence: true, unless: -> { self.solo_respuesta_observaciones || self.solo_guarda_archivos }

  # DZC 2019-06-11 17:56:58 se agrega para validar :con_extension
  validate :extension_valida?, unless: -> { self.tarea_codigo == Tarea::COD_APL_018 || self.solo_guarda_archivos}

  mount_uploaders :archivos_anexos, ArchivosAnexosInformeAcuerdosUploader
  mount_uploaders :archivos_anexos_posteriores_firmas, ArchivosAnexosPosterioresFirmasInformeAcuerdosUploader #DZC se agrega para tarea APL-023

  # DZC 2018-11-02 20:08:24 valida que los archivos subidos se correspondan con el tipo de archivo
  # DZC 2018-11-08 13:54:26 evita la validación de la existencia de los archivos de evidencia en la APL-018
  # se incluye tarea 20 para agregar respuesta a observaciones
  # se agrega tarea 23 para no lanzar error al enviar sin tener archivos, ahora lo exige posterior al envio
  validates :archivos_anexos_posteriores_firmas, presence: true, on: :update, unless: -> {[Tarea::COD_APL_018,Tarea::COD_APL_020,Tarea::COD_APL_023].include?(self.tarea_codigo)}

  enum tipo_acuerdo: [:desde_firma_acuerdo, :desde_aprobación_de_la_adhesión]
  enum mecanismo_implementacion_palabras_claves: [:tipo_acuerdo, :plazo_maximo_adhesion, :plazo_finalizacion_implementacion]
  enum mecanismo_evaluacion_palabras_claves: [:plazo_maximo, :plazo_maximo_neto, :adhesiones, :con_validacion]
  enum vigencia_acuerdo_palabras_claves: [:plazo_vigencia_acuerdo]

  # DZC 2018-11-12 10:44:17 se agrega variable archivos_por_eliminar
  attr_accessor :fecha_firma, :fecha_vigencia_acuerdo, :fecha_plazo_maximo_adhesion, :fecha_plazo_finalizacion_implementacion, :fecha_plazo_maximo, :fecha_plazo_maximo_neto, :auditorias, :tarea_codigo, :archivos_por_eliminar, :accion

  # DZC 2019-06-11 17:04:55 se agrega para evitar validación en solo guardado de archivos
  attr_accessor :solo_guarda_archivos

  attr_accessor :solo_respuesta_observaciones

  attr_accessor :acta_convocatoria

  attr_accessor :tipo_linea_seleccionada

  has_many :comentarios_informe_acuerdos, dependent: :destroy
	accepts_nested_attributes_for :comentarios_informe_acuerdos, allow_destroy: true

  # def agrega_id_archivos_anexos
  #   unless self.archivo_anexos.blank?
  #     self.archivo_anexos.each_with_index do |ae, indice|
  #       ae.indice = indice
  #     end
  #   end
  # end

  # def plazos_auditorias?
  #
  #   auditorias = []
  #   self.auditorias.each do |k,v|
  #    auditorias << k.each do |k2,v2|
  #     {k2.to_sym => v2}
  #     end
  #   end
  #   se_validan = true
  #   af = []
  #   auditorias.each do |a|
  #     af << a if a.has_key?(:final)
  #   end
  #   #DZC no hay o hay mas de 1 auditoria final
  #   if af.size != 1
  #     se_validan = false
  #   else
  #     af = af.first
  #   end
  #   if se_validan
  #     auditorias.each do |a|
  #       unless a[:id] == af[:id]
  #         #DZC el plazo de una auditoria intermedia es mayor
  #         se_validan = false if (a[:plazo].to_i > af[:plazo].to_i)
  #       end
  #     end
  #   end
  #   se_validan
  # end

  def self.palabras_claves grupo
    data = {}
    data_vigencia_acuerdo = {
      plazo_vigencia_acuerdo: :plazo_vigencia_acuerdo
    }
    data_mecanismo_implementacion = {
      plazo_implementacion_y_certificacion: :tipo_acuerdo,
      plazo_maximo_adhesion: :plazo_maximo_adhesion,
      plazo_finalizacion_implementacion: :plazo_finalizacion_implementacion,
      adhesiones: :adhesiones
    }
    data_vigencia_certificacion = {
      vigencia_certificacion_final: :vigencia_certificacion_final
    }
    if grupo == "mecanismo_de_implementacion"
      data = data_mecanismo_implementacion
    elsif grupo == "vigencia_acuerdo"
      data = data_vigencia_acuerdo
    elsif grupo == "vigencia_certificacion"
      data = data_vigencia_certificacion
    else
      data = data_vigencia_acuerdo.merge(data_mecanismo_implementacion).merge(data_vigencia_certificacion)
    end
    data
  end

  # DZC 2019-06-11 17:58:51 se agrega para validar existencia de atributo :con_extension
  def extension_valida?
    self.con_extension.present? || [true,false].include?(self.con_extension)
  end

  def plazos_correctos? #DZC MODIFICAR PREGUNTANDO VALIDACIONES DE PENDIENTES
    # si no se envia la variable validamos
    if solo_respuesta_observaciones.nil?
      flujo = self.manifestacion_de_interes.flujo
      auditoria_intermedia_maxima = self.auditorias.select{|a| a[:final].blank?}.sort_by{|a| a[:plazo]}.reverse.first
      auditoria_final = self.auditorias.select{|a| a[:final].present?}
      unless (auditoria_final.blank? || auditoria_final.size > 1)
        auditoria_final = auditoria_final.first
        paf = auditoria_final[:plazo].to_i
        pmai = auditoria_intermedia_maxima.present? ?  auditoria_intermedia_maxima[:plazo].to_i : paf #DZC 2018-11-15 11:33:52 se iguala el plazo de la auditoría intermédia al de la final, si la intermedia no existe
        ta = self.tipo_acuerdo
        pma = self.plazo_maximo_adhesion #DZC (1)
        pfi = self.plazo_finalizacion_implementacion #DZC (2)
        pm = self.plazo_maximo #DZC (3)
        pmn = self.plazo_maximo_neto #DZC (4)
        pma_nombre = "plazo máximo de adhesión"
        pfi_nombre ="plazo de finalización de la implementación"
        pm_nombre ="plazo máximo para iniciar el proceso de certificación final"
        pmn_nombre ="plazo máximo neto para iniciar el proceso de certificación final"
        pmai_nombre ="plazo mas alto entre las auditorías intermedias"
        paf_nombre ="plazo de la auditoría final"
        errors.add(:plazo_maximo_adhesion, "El plazo debe ser mayor a 0") if (pma < 1)
        errors.add(:plazo_finalizacion_implementacion, "El plazo debe ser mayor a 0") if (pfi <1)
        errors.add(:plazo_maximo_neto, "El plazo debe ser mayor a 0") if (pma < 1)
        #DZC (pmai > paf)
        if (pmai > paf)
          errors.messages[:auditorias] += ["El #{pmai_nombre} (#{pmai}) NO PUEDE ser MAYOR al #{paf_nombre} (#{paf})."]
        else
          #DZC 2019-06-11 16:36:50 se modifican los textos de las validaciones para mayor claridad
          if ta != 'simultáneo'
            if (!pm.blank? && pm > 0) #DZC pm existe
              errors.add(:plazo_maximo, "El #{pm_nombre} (#{pm}) DEBE SER MAYOR O IGUAL que el #{pfi_nombre} (#{pfi}).") if (pfi > pm)
              errors.add(:plazo_maximo_neto, "El #{pmn_nombre} DEBE SER MAYOR O IGUAL que el #{pfi_nombre}.") if (pmn < pfi)
              errors.add(:plazo_maximo_neto, "El #{pmn_nombre} (#{pmn}) DEBE SER MAYOR O IGUAL al resultado de la suma entre #{pm_nombre} y el #{pma_nombre} (#{(pm + pma)}).") if (pmn < (pm + pma))
              errors.add(:plazo_maximo, "El #{pm_nombre} (#{pm}) DEBE SER MAYOR O IGUAL al #{pmai_nombre} (#{pmai}).") if (pm < pmai)
              errors.add(:plazo_maximo, "El #{paf_nombre} (#{paf}) DEBE SER MENOR O IGUAL al #{pm_nombre} (#{pm}).") if (paf > pm)
            else
              errors.add(:plazo_maximo_neto, "El #{pmn_nombre} (#{pmn}) DEBE SER MAYOR O IGUAL que el #{pma_nombre} (#{(pma)}).") if (pmn < pma)
              errors.add(:plazo_maximo_neto, "El #{pmn_nombre} (#{pmn}) DEBE SER MAYOR O IGUAL al #{pmai_nombre} (#{pmai}).") if (pmn < pmai)
              errors.add(:plazo_maximo_neto, "El #{paf_nombre} (#{paf}) DEBE SER MENOR O IGUAL al #{pmn_nombre} (#{pmn}).") if (paf > pmn)
            end
          else
            #DZC tipo de acuerdo simultáneo
            errors.add(:plazo_maximo_neto, "El #{pmn_nombre} (#{pmn}) DEBE SER MAYOR O IGUAL al #{pma_nombre} (#{pma}).") if (pmn < pma)
            errors.add(:plazo_maximo_neto, "El #{pmn_nombre} (#{pmn}) DEBE SER MAYOR O IGUAL al #{pfi_nombre} (#{pfi}).") if (pmn < pfi)
            errors.add(:plazo_maximo_neto, "El #{pmn_nombre} (#{pmn}) DEBE SER MAYOR O IGUAL al #{pmai_nombre} (#{pmai}).") if (pmn < pmai)
            errors.add(:plazo_maximo_neto, "El #{paf_nombre} (#{paf}) DEBE SER MENOR O IGUAL al #{pmn_nombre} (#{pmn}).") if (paf > pmn)
          end
        end
        plazos_correctos = (errors.size == 0)? true : false
      else
        errors.messages[:auditorias] += [": debe existir una Auditoría Final, y debe ser única."]
        plazos_correctos = false
      end

      plazos_correctos
    end
  end

  def _a_datos(auditorias)

    datos = self.attributes
    datos.each{ |k,v| datos[k] = "" if v.nil? }
    datos["archivos_anexos"] = datos["archivos_anexos"].join(",")
    datos["auditorias"] = auditorias.map{|aud| {"nombre" => (aud.nombre rescue aud[:nombre])}}
    datos
  end

  #DZC se agrega solo para cargar archivos anexos posteriores a firma en APL-023
  def _a_datos_archivos_anexos_posteriores_firmas
    datos = self.attributes
    datos.each{ |k,v| datos[k] = "" if v.nil? }
    datos["archivos_anexos_posteriores_firmas"] = datos["archivos_anexos_posteriores_firmas"].join(",")
    datos
  end

  #convierte la data a html usando un partial
  def _a_html_string
    flujo_id = self.manifestacion_de_interes.flujo.id
    auditorias = Auditoria.where(flujo_id: flujo_id).all
    actores_mapa = MapaDeActor.where(flujo_id: flujo_id, rol_id: Rol::FIRMANTE).includes([:rol, persona: [:user,:contribuyente, persona_cargos: [:cargo]]]).all

    ActionView::Base.new(
      Rails.configuration.paths["app/views"]).render(
      :partial => 'acuerdo_actores/informe', :format => :txt,
      :locals => {
        datos: self::_a_datos(auditorias),
        actores_mapa: actores_mapa,
        es_descargable: true
      }
    )
  end

  def fecha_desde_tipo_acuerdo
    fecha_comparativa = nil
    begin
      #dentro de begin porque puede darse el caso que algo no exista, si es asi no se puede obtener fecha nomas
      if self.tipo_acuerdo == "desde_firma_acuerdo"
        #si es desde firma tomo la fecha firma
        fecha_comparativa = self.manifestacion_de_interes.firma_fecha_hora.nil? ? self.manifestacion_de_interes.firma_fecha : self.manifestacion_de_interes.firma_fecha_hora
      else
        #si es desde fecha aprobacion de adhesion
        #apl-028 es la que dice si fue aprobada la adhesion ¿y como?, si al menos un elemento fue aprobado
        #¿y como se si un elemento fue aprobado?, porque se agrega a la tabla adhesion elementos
        #tonce si tiene al menos un elemento en tabla adhesion_elementos ya tenemos fecha
        #debemos ordenar por fecha y tomar la primera, ya que se pueden seguir aprobando elementos post envio
        flujo = self.manifestacion_de_interes.flujo
        if flujo.adhesion_elementos.length > 0
          fecha_comparativa = flujo.adhesion_elementos.order(created_at: :asc).first.created_at.to_date
        end
      end
    rescue
    end
    fecha_comparativa
  end

  #DZC calcula fechas
  def calcula_fechas
    self.calcula_fecha_firma
    self.calcula_fecha_vigencia_acuerdo
    self.calcula_fecha_plazo_maximo_adhesion
    self.calcula_fecha_plazo_finalizacion_implementacion
    self.calcula_fecha_plazo_maximo
    self.calcula_fecha_plazo_maximo_neto
  end

  def calcula_fecha_firma
    self.fecha_firma = self.manifestacion_de_interes.firma_fecha_hora.nil? ? self.manifestacion_de_interes.firma_fecha : self.manifestacion_de_interes.firma_fecha_hora
  end

  def calcula_fecha_vigencia_acuerdo(anios=self.plazo_vigencia_acuerdo)

    anios = anios.blank? ? 0 : anios
    self.fecha_vigencia_acuerdo = self.calcula_fecha_firma + anios.years
  end

  def calcula_fecha_plazo_maximo_adhesion(meses=self.plazo_maximo_adhesion)

    meses = meses.blank? ? 0 : meses
    self.fecha_plazo_maximo_adhesion = self.calcula_fecha_firma + meses.months
  end

  #DZC depende del tipo_acuerdo
  def calcula_fecha_plazo_finalizacion_implementacion(meses=self.plazo_finalizacion_implementacion)

    meses = meses.blank? ? 0 : meses
    self.fecha_plazo_finalizacion_implementacion = self.calcula_fecha_firma + meses.months
  end

  def calcula_fecha_plazo_maximo(meses=self.plazo_maximo)

    meses = meses.blank? ? 0 : meses
    self.fecha_plazo_maximo = self.calcula_fecha_plazo_maximo_adhesion + meses.months
  end

  def calcula_fecha_plazo_maximo_neto(meses=self.plazo_maximo_neto)
    meses = meses.blank? ? 0 : meses
    self.fecha_plazo_maximo_neto = self.calcula_fecha_firma + meses.months
  end

  def plazo_maximo_adhesion_pendiente?
    self.calcula_fecha_plazo_maximo_adhesion
    Time.now <= self.fecha_plazo_maximo_adhesion
  end

  def plazo_finalizacion_implementacion_pendiente?
    self.calcula_fecha_plazo_finalizacion_implementacion
    Time.now <= self.fecha_plazo_finalizacion_implementacion
  end

  def plazo_maximo_pendiente?
    self.calcula_fecha_plazo_maximo
    Time.now <= self.fecha_plazo_maximo
  end

  def plazo_maximo_neto_pendiente?
    self.calcula_fecha_plazo_maximo_neto
    Time.now <= self.fecha_plazo_maximo_neto
  end

  def descargar
    pdf = WickedPdf.new.pdf_from_string(self._a_html_string)

    #pdf = Prawn::Document.new
    #sizes = { small: 10, normal: 13, large: 20, huge: 32 }
    #data = self.__contenido(self._a_html_string.as_hash,130,:justify,sizes)
    #data.each do |line|
    #  value = line[:value]
    #  attributes = line[:attributes].blank? ? {} : line[:attributes]
    #  pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")
    #  if line[:image] == true
    #    pdf.image(line[:value],attributes)
    #  else
    #    if attributes.has_key?(:color) && attributes[:color].present?
    #      pdf.fill_color attributes[:color]
    #      attributes.delete(:color)
    #    end
    #    if attributes.has_key?(:style)
    #      attributes[:style].each do |style|
    #        pdf.font "Helvetica", style: style.to_sym
    #      end
    #      attributes.delete(:style)
    #    end
    #    attributes[:align] = :left unless [:right,:center,:justify].include?(attributes[:align])
    #    pdf.text(value,attributes)
    #  end
    #end
    pdf
  end

  def __contenido(editor_hash,image_width,justify,sizes)
    data  = []
    # Cabecera fija con el logo de la agencia
    data  << { value: Rails.root.join('app','assets','images','logo-ascc-nuevo-png').to_s, attributes: { width: image_width, in_header: true }, image: true }
    data  << { value: "\n"}
    editor_hash.each do |k,lines|
      skip_to_next = nil
      lines.each_with_index do |line,i|
        attributes = line["attributes"]
        style = []
        size  = sizes[:normal]
        align = :left
        color = '000000'
        nxti  = lines[i+1]

        # Ignoramos los saltos de líneas continuos
        unless skip_to_next
          # Normalizamos attributos cuando esto existen
          unless attributes.blank?
            bold    = ( attributes["bold"]==true ? :bold : nil )
            italic  = ( attributes["italic"]==true ? :italic : nil )
            color   = ( attributes["color"]==true ? attributes["color"] : nil )
            style   = [bold,italic].compact
            size    = attributes["size"].blank? ? sizes[:normal] : sizes[attributes["size"].to_sym]
            color   = attributes["color"].to_s.upcase.sub(/[^0-9A-Z]/,'') unless attributes["color"].blank?
          end

          # Si la línea siguiente es un salto de línea y posee los atributos de alineación de la línea actual, entonces se presume que no es
          # un salto de línea deseado. Es por esto que nos "robamos" su atributo de centrado y la ignoramos.
          if ! nxti.blank? && nxti["insert"].gsub(/\n/,'').blank? && nxti.has_key?("attributes") && nxti["attributes"].has_key?("align")
            align = ( (nxti["attributes"]["align"]=="justify") ? justify : nxti["attributes"]["align"].to_sym )
            # A veces vienen dos saltos de líneas seguidos. Si la línea subsiguiente es un salto de línea sin atributo,
            # entonces quiere decir que el salto es deseado en este caso.
            if ( nxti["insert"].match(/\n{2,}/).blank? && ! lines[i+2].blank? )
              skip_to_next = true
            end
          elsif ! attributes.blank? && ! attributes["align"].blank?
            align = ( (attributes["align"]=="justify") ? justify : attributes["align"].to_sym )
          end

          attributes = { style: style, size: size, align: align, color: color }

          # Procesamos de forma disntas las líneas que empiezan con uno o más salto de línea
          if line["insert"].match(/^[\n]{2,}$/).blank?
            values = []
            # Dividimos por salto de línea y aprovechamos de hacer el reemplazo de etiquetas
            line["insert"].to_s.gsub(/^\n+/,'').split("\n").each do |s|
              values << s
            end

            # Si values es cero, es porque esta línea posee solo salto de líneas
            if values.size == 0
              # No queremos saltos de líneas pero lo aceptamos si la anterior línea también lo era.
              data << { value: "\n" } if skip_to_next == false
            else
              # Agregamos cada parte encontrada como una línea nueva
              values.each do |value|
                data << { value: value, attributes: attributes }
              end
            end
          else
            splited_line=line["insert"].gsub(/\n{2}/,"\n").split("")
            chars_between_new_lines=""
            # Dividimos por palabra para evitar que saltos de líneas entre palabras
            splited_line.each_with_index do |new_line,i|
              if new_line == "\n"
                data << { value: new_line }
              else
                # juntamos las palabras en una línea hasta nos encontramos con un salto de línea
                chars_between_new_lines+=new_line
                if splited_line[i+1].blank?
                  data << { value: chars_between_new_lines, attributes: attributes }
                  chars_between_new_lines = ""
                end
              end
            end
          end
          # Reiniciamos su valor a nil, mientras no sea true
          skip_to_next = nil unless skip_to_next
        else
          # Al estar ignorado, este valor pasa de nil a false
          skip_to_next = false
        end
      end
    end
    data
  end

end
