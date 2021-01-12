class CrearExcel
  require 'axlsx'
  attr_accessor :titulos, :datos, :nombre_hoja, :ruta, :salida, :titulos_informe, :datos_informe, :nombre_hoja_informe

  ## metodo inicializador
  # titulos => ['campo1','campo2',...'campoN']
  # datos => [['dato1','dato2',...'datoN'],['dato1','dato2',...'datoN']]
  # nombre_hoja => "titulo hoja"
  # ruta => "fake_path/mis_documentos/archivo.xlsx"
  def initialize(params)
    @titulos = params[:titulos]
    @titulos_informe = params[:titulos_informe]
    @datos = params[:datos]
    @datos_informe = params[:datos_informe]
    @nombre_hoja = params[:nombre_hoja]
    @nombre_hoja_informe = params[:nombre_hoja_informe]
    @ruta = params[:ruta]
  end

  ## metodo que crea el libro y si se entrega la ruta, crea el archivo en el servidor
  def crear_libro
    p = Axlsx::Package.new
    # para poder manejar numeros
    p.use_shared_strings = true
    # creo el libro de trabajo
    p.workbook do |wb|
      # definicion de estilos bases
      estilos = wb.styles
      titulo = estilos.add_style :sz => 15, :b => true, :u => true
      defecto = estilos.add_style format_code: '@'
      negrita = estilos.add_style :border => Axlsx::STYLE_THIN_BORDER, :b => true 
      cabecera = estilos.add_style :bg_color => 'cc7a00', :fg_color => 'FF', :b => true, :locked => true
      desprotegido = estilos.add_style :locked => false
      protegido = estilos.add_style :locked => true
      wb.add_worksheet(:name => nombre_hoja) do |ws|
        ws.add_row titulos.map{|v|
          # cambiamos el campo_id por campo id
          unless (v.last(3).downcase == "_id") 
            v.humanize
          else
            v.first(v.size - 3).humanize+" id"
          end
        }, :style => cabecera

        # Pobla hoja
        datos.each do |da|
          ws.add_row da, :style => defecto
        end
      end
    end
    unless ruta.blank?
      # creo el archivo de salida
      @salida = p.serialize ("#{ruta}")
    else
      @salida = p
    end
    @salida
  end

  ## metodo que crea el libro de observaciones agrupadas y si se entrega la ruta, crea el archivo en el servidor
  def crear_libro_observaciones
    p = Axlsx::Package.new
    # para poder manejar numeros
    p.use_shared_strings = true
    # creo el libro de trabajo
    p.workbook do |wb|
      # definicion de estilos bases
      estilos = wb.styles
      titulo = estilos.add_style :sz => 15, :b => true, :u => true
      defecto = estilos.add_style format_code: '@'
      negrita = estilos.add_style :border => Axlsx::STYLE_THIN_BORDER, :b => true 
      cabecera = estilos.add_style :bg_color => 'cc7a00', :fg_color => 'FF', :b => true, :locked => true
      desprotegido = estilos.add_style :locked => false
      protegido = estilos.add_style :locked => true
      agrupadas_verical = estilos.add_style format_code: '@', alignment: {:vertical => :center}
      wb.add_worksheet(:name => nombre_hoja) do |ws|
        ws.add_row titulos.map{|v|
          # cambiamos el campo_id por campo id
          unless (v.last(3).downcase == "_id") 
            v.humanize
          else
            v.first(v.size - 3).humanize+" id"
          end
        }, :style => cabecera
        # Pobla hoja
        meta_current_row = 2
        datos.each do |meta_id,meta|
          meta_rowspan = 0
          accion_current_row = meta_current_row
          meta[:acciones].each do |accion_id, accion|
            accion_rowspan = 0
            materia_current_row = accion_current_row
            accion[:materias].each do |materia_id, materia|
              materia_rowspan = 0
              alcance_current_row = materia_current_row
              materia[:alcances].each do |alcance_id, alcance|
                alcance_rowspan = 0
                alcance[:data].each do |comentario|
                  fila = []
                  fila << meta[:nombre]
                  fila << accion[:nombre]
                  fila << materia[:nombre]
                  fila << alcance[:nombre]
                  fila << comentario[:nombre]
                  fila << comentario[:rut]
                  fila << comentario[:email]
                  fila << comentario[:fecha_hora]
                  fila << comentario[:comentario]
                  ws.add_row fila, :style => agrupadas_verical
                  alcance_rowspan += 1
                end
                #si tiene rowspan los juntamos
                ws.merge_cells("D#{alcance_current_row}:D#{alcance_current_row+alcance_rowspan-1}") if alcance_rowspan > 1
                #actualizo el current_row
                alcance_current_row += alcance_rowspan
                #le paso al padre el span que hicimos en hijo
                materia_rowspan += alcance_rowspan
              end
              #si tiene rowspan los juntamos
              ws.merge_cells("C#{materia_current_row}:C#{materia_current_row+materia_rowspan-1}") if materia_rowspan > 1
              #actualizo el current_row
              materia_current_row += materia_rowspan
              #le paso al padre el span que hicimos en hijo
              accion_rowspan += materia_rowspan
            end
            #si tiene rowspan los juntamos
            ws.merge_cells("B#{accion_current_row}:B#{accion_current_row+accion_rowspan-1}") if accion_rowspan > 1
            #actualizo el current_row
            accion_current_row += accion_rowspan
            #le paso al padre el span que hicimos en hijo
            meta_rowspan += accion_rowspan
          end
          #si tiene rowspan los juntamos
          ws.merge_cells("A#{meta_current_row}:A#{meta_current_row+meta_rowspan-1}") if meta_rowspan > 1
          #actualizo el current_row
          meta_current_row += meta_rowspan
        end
      end
      wb.add_worksheet(:name => nombre_hoja_informe) do |ws|
        ws.add_row titulos_informe.map{|v|
          # cambiamos el campo_id por campo id
          unless (v.last(3).downcase == "_id") 
            v.humanize
          else
            v.first(v.size - 3).humanize+" id"
          end
        }, :style => cabecera
        datos_informe.each do |dato|
          ws.add_row dato
        end
      end
    end
    unless ruta.blank?
      # creo el archivo de salida
      @salida = p.serialize ("#{ruta}")
    else
      @salida = p
    end
    @salida
  end
end