class DescargableTarea < ApplicationRecord
  mount_uploader :archivo, ArchivosDescargableTareaUploader
  enum formato: [:docx,:pdf,:xlsx]
  belongs_to :tarea
  validates :nombre, presence: true
  validates :tarea_id, presence: true
  validates :codigo, presence: true, format: { with: /\A(APL|PPF|FPL|PRO)-[\0-9]{3}(\.[0-9])?-DES-[\0-9]{3}\Z/ }
  validates :formato, presence: true
  validates :contenido, presence: true, unless: -> { subido == true }
  validates :archivo, presence: true, if: -> { subido == true }

  validates_uniqueness_of :codigo, scope: :tarea_id
  validate :formato_en_archivos_generados

  def formato_en_archivos_generados
    if subido == false && ! ["docx","pdf"].include?(self.formato)
      errors.add(:formato,"Los archivos creados desde el editor, sólo pueden ser de tipo PDF o DOCX")
    end
    if self.subido
      self.contenido = nil
    end
  end

  def file(replaces)
    #if self.archivo.file.present? #DZC para el caso de que no exista el archivo 
    #Es necesario cuando se genera por primera vez, desde el mantenedor de archivos.-
      content = self.contenido.to_s.as_hash
      subido = self.subido.present? ? self.subido : false
      if self.formato.to_sym == :docx
        sizes = { small: 20, normal: 24, large: 28, huge: 56 }
        document=DescargableTarea.word_document(DescargableTarea.__contenido(replaces,content,250,:both,sizes))
        document.save!
        content = File.open(document.file_path).read
        filename = document.file_name
        nombre_archivo = self.nombre.present? ? "#{self.nombre}.docx" : "archivo.docx"
        FileUtils.rm(document.file_path)
        return {
          format: :docx,
          content: content,
          filename: nombre_archivo
        }
      elsif self.formato.to_sym == :pdf
        nombre_archivo = self.nombre.present? ? "#{self.nombre}.pdf" : "archivo.pdf"        
        sizes = { small: 10, normal: 13, large: 20, huge: 32 }
        pdf = DescargableTarea.pdf_document(DescargableTarea.__contenido(replaces,content,130,:justify,sizes))
        return {
          format: :pdf,
          content: subido ? self.archivo.file.read : pdf.render,
          filename: nombre_archivo
        }
      elsif self.formato.to_sym == :xlsx
        return {
          format: :xlsx,
          content: File.open("#{self.archivo.file.path}").read,
          filename: "#{self.nombre}.xlsx"
        }
      end
    #end
  end

	def self.word_document(data)
		temp_name = SecureRandom.hex(28)+"-"+Time.now.getutc.to_i.to_s
    ruta = "#{Rails.root}/tmp/descargables/"
    FileUtils.mkdir_p(ruta) unless File.exist?(ruta)
		PureDocx.create(Rails.root.join("tmp","descargables","#{temp_name}.docx"), paginate_pages: 'right') do |doc|
			data.each do |line|
				value = line[:value]
				attributes = line[:attributes].blank? ? {} : line[:attributes]
				if line[:image] == true
					value = [doc.image(value,attributes)]
				else
					value = [doc.text(value,attributes)]
				end
				if attributes[:in_header] == true
					doc.header(value)
				else
					doc.content(value)
				end
			end
		end
	end

	def self.pdf_document(data)
    pdf = Prawn::Document.new
    data.each do |line|
      value = line[:value]
      attributes = line[:attributes].blank? ? {} : line[:attributes]
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")
      if line[:image] == true
        pdf.image(line[:value],attributes)
      else
        if attributes.has_key?(:color) && attributes[:color].present?
          pdf.fill_color attributes[:color]
          attributes.delete(:color)
        end
        if attributes.has_key?(:style)
          attributes[:style].each do |style|
            pdf.font "Helvetica", style: style.to_sym
          end
          attributes.delete(:style)
        end
        attributes[:align] = :left unless [:right,:center,:justify].include?(attributes[:align])
        pdf.text(value,attributes)
      end
    end
    pdf
	end

	def self.__contenido(replace,editor_hash,image_width,justify,sizes)
    data  = []
    # Cabecera fija con el logo de la agencia
    data  << { value: Rails.root.join('app','assets','images','logo-ascc.jpg').to_s, attributes: { width: image_width, in_header: true }, image: true }
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
            	values << replace_values(replace,s)
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
                  data << { value: replace_values(replace,chars_between_new_lines), attributes: attributes }
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
