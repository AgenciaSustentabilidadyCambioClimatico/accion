class ExportaExcel
  # Requisitos: 
  # => ruta: file que sera sobreescrito (path + nombre archivo + extension)
  # => titulos: hash con key = nombre campo y value = dependencia de dominios
  # => dominios: hash con key = nombre dominio y value = array de datos
  # => datos: array con arrays de datos
  # => nombre_hoja: nombre de la primera hoja asociada a datos
  # => hiper: hash con key = hiperenlaces con key correspondiente al nombre de la columna
  def self.formato (ruta, titulos, dominios, datos=[], nombre_hoja="Hoja 1", hiper={}, bloqueo=[])
    require 'axlsx'

    titulos_nombres = titulos.map{|k,v| k.to_s}
    titulos_dominios = titulos.map{|k,v| v}
    dominios_nombres = dominios.map{|k,v| k.to_s}
    dominios_datos = dominios.map{|k,v| v}

    # Setea todo a string, fix numeros
    titulos_types = [*1..titulos_nombres.size].fill(:string)
    dominios_types = [*1..dominios_nombres.size].fill(:string)

    p = Axlsx::Package.new
    # para poder manejar numeros
    p.use_shared_strings = true
    # creo el libro de trabajo
    p.workbook do |wb|
      # definicion de estilos
      estilos = wb.styles
      titulo = estilos.add_style :sz => 15, :b => true, :u => true
      defecto = estilos.add_style format_code: '@'
      negrita = estilos.add_style :border => Axlsx::STYLE_THIN_BORDER, :b => true 
      cabecera = estilos.add_style :bg_color => 'cc7a00', :fg_color => 'FF', :b => true, :locked => true
      desprotegido = estilos.add_style :locked => false
      protegido = estilos.add_style :locked => true
      wb.add_worksheet(:name => nombre_hoja) do |ws|
        ws.add_row titulos_nombres.map{|v|
           
          unless (v.last(3).downcase == "_id") 
            v.humanize
          else
            v.first(v.size - 3).humanize+" id"
          end
        }, :style => cabecera
        # TODO: crear enlace dinamico
        #ws.add_hyperlink :location => 'http://www.sii.cl/ayudas/ayudas_por_servicios/1956-codigos-1959.html', :ref => 'F1'
        #DZC Agrega hiperenlaces a celda de título específica
        if !hiper.nil?
          titulos_nombres.each_with_index do |t, ind|
            
            hiper.each do |k,v|
              if k.upcase == t.upcase
                if pos_tit < 26 #DZC caso con sola letra (0..25)
                  letra_columna = (ind+65).chr
                elsif pos_tit < 676 #DZC caso con dos letras (26..675)
                  letra_columna = ((ind/26)+65).chr + ((ind%26)+65).chr
                else #DZC caso con tres letras (676..)
                  letra_columna = (((ind/676)+65)-1).chr + ((ind/26)+65).chr + ((ind%26)+65).chr
                end
                ws.add_hyperlink :location => '#{v}', :ref => '#{letra_columna}1' #DZC agrega el hiperenlace
              end   
            end
          end
        end

        control_dom = []
        # Asocia columnas de datos con dominios
        titulos_dominios.each_with_index do |t, ind|
          unless t.nil?
            pos_dom = dominios_nombres.index(t)
            if (pos_dom < 26) #DZC caso con sola letra (0..25)
              letra_columna = (pos_dom+65).chr
            elsif pos_dom < 676 #DZC caso con dos letras (26..675)
              letra_columna = ((pos_dom/26)+65).chr + ((pos_dom%26)+65).chr
            else #DZC caso con tres letras (676..)
              letra_columna = (((pos_dom/676)+65)-1).chr + ((pos_dom/26)+65).chr + ((pos_dom%26)+65).chr
            end
            control_dom << {
              #65 es la base ASCII para letras mayusculas (A-Z) (65 - 90)
              # TODO: ajustar para mas de 26 dominios - DZC hecho
              posicion_dominio: letra_columna, 
              posicion_celda: ind,
              titulo: t.upcase
            }
            
          end
        end

        # Pobla hoja
        datos.each do |da|
          ws.add_row da, :style => defecto, types: titulos_types
          control_dom.each do |cd|
            # DZC 2018-10-09 11:13:49 Se modifica la fórmula para que mantenga el rango al copiarse filas
            ws.add_data_validation(ws.rows.last.cells[cd[:posicion_celda]].r, {
              :type => :list,
              :formula1 => "Dominios!#{cd[:posicion_dominio]}$2:#{cd[:posicion_dominio]}$1000000",
              :showDropDown => false,
              :showInputMessage => true,
              :promptTitle => cd[:titulo],
              :prompt => 'Por favor seleccione'
            })
          end
        end
        # Crea fila vacía con dominios
        empty = [*1..titulos_nombres.size].fill("")
        ws.add_row empty, :style => defecto, types: titulos_types
        control_dom.each do |cd|
          # DZC 2018-10-09 11:13:49 Se modifica la fórmula para que mantenga el rango al copiarse filas
          ws.add_data_validation(ws.rows.last.cells[cd[:posicion_celda]].r, {
            :type => :list,
            :formula1 => "Dominios!#{cd[:posicion_dominio]}$2:#{cd[:posicion_dominio]}$1000000",
            :showDropDown => false,
            :showInputMessage => true,
            :promptTitle => cd[:titulo],
            :prompt => 'Por favor seleccione'
          })
        end
        #bloque columnas espeficas
        if bloqueo.present?
          ws.sheet_protection.password = 'p4$$w0rd'
          ws.add_row bloqueo[0] # These cells will be locked
          ws.add_row bloqueo[1], style: desprotegido # these cells will not!
        end
      end      

      wb.add_worksheet(:name => 'Dominios') do |ws|
        ws.add_row dominios_nombres.map{|v| v.humanize}, :style => cabecera

        # Transforma arrays horizontales a verticales para excel
        dom_format = Array.new(dominios_datos.map(&:length).max){|i| dominios_datos.map{|e| e[i]}}
        dom_format.each do |d|
          ws.add_row d, :style => defecto, types: dominios_types
        end
        ws.sheet_protection do |protection|
          protection.password = 'p4$$w0rd'
          protection.auto_filter = true
        end
      end
    end
    # creo el archivo de salida
    p.serialize ("#{ruta}")
  end



end