class CrearExcel
  require 'axlsx'
  attr_accessor :titulos, :datos, :nombre_hoja, :ruta, :salida

  ## metodo inicializador
  # titulos => ['campo1','campo2',...'campoN']
  # datos => [['dato1','dato2',...'datoN'],['dato1','dato2',...'datoN']]
  # nombre_hoja => "titulo hoja"
  # ruta => "fake_path/mis_documentos/archivo.xlsx"
  def initialize(params)
    @titulos = params[:titulos]
    @datos = params[:datos]
    @nombre_hoja = params[:nombre_hoja]
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
        # definimos la fila base para agrupar
        ultimo_numero_meta = 2
        ultimo_numero_accion = 2
        # Pobla hoja
        datos.each do |nombre,acciones_hashed|
          # obtenemos el rowspan
          rowspan_meta = acciones_hashed[:rowspan]
          # recorremos las acciones de cada meta
          acciones_hashed[:acciones].each do |nombre_accion, comentarios_hashed|
            rowspan_accion = comentarios_hashed[:rowspan]
            # si hay comentarios agregamos la demas informacion sino agregamos una fila casi vacia
            if comentarios_hashed[:datos].size > 0
              # recorremos los comentarios de cada accion
              comentarios_hashed[:datos].each_with_index do |comentario_hash,index|
                fila = []
                fila << nombre
                fila << nombre_accion
                fila << comentario_hash[:nombre]
                fila << comentario_hash[:rut]
                fila << comentario_hash[:email]
                fila << comentario_hash[:comentario]
                ws.add_row fila, :style => agrupadas_verical
              end
            else
              fila = []
              fila << nombre
              fila << nombre_accion
              ws.add_row fila, :style => agrupadas_verical
            end
            # unimos la columna nombre accion
            ws.merge_cells("B#{ultimo_numero_accion}:B#{ultimo_numero_accion+rowspan_accion-1}") if rowspan_accion > 1
            # actualizamos el numero para rowspan
            ultimo_numero_accion += rowspan_accion
          end
          # unimos la columna nombre meta
          ws.merge_cells("A#{ultimo_numero_meta}:A#{ultimo_numero_meta+rowspan_meta-1}") if rowspan_meta > 1
          # actualizamos el numero para rowspan
          ultimo_numero_meta += rowspan_meta
        end
      end
    end
    unless ruta.blank?
      # creo el archivo de salida
      @salida = p.serialize ("#{ruta}")
    else
      @salida = nil
    end
    @salida
  end
end