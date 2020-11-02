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
      @salida = nil
    end
    @salida
  end
end