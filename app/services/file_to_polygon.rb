class FileToPolygon

  def initialize(filepath)
    @filepath = filepath
    @file = File.new(filepath, "r")
    @extension = File.extname(filepath)
    @content = File.read(filepath)
  end

  def filepath
    @filepath
  end

  def file
    @file
  end

  def extension
    @extension
  end

  def content
    @content
  end

  def map_data
    #array con cordenadas
    # coordinates = [
    #   [-69.57177734375,-27.237394616635353],
    #   [-72.64794921875,-31.14922019189199],
    #   [-71.06591796875,-27.15922207884954],
    #   [-69.57177734375,-27.237394616635353]
    # ]

    coordinates = []

    begin
      #Segun extension leo el contenido
      case extension
      when ".kml"
        coordinates = kml_converter(content)
      when '.kmz'
        #kmz es un zip que tiene un kml LOL
        kml_content = nil
        Zip::File.open(filepath) do |zipfile|
          kml_content = zipfile.first.get_input_stream.read
        end
        coordinates = kml_converter(kml_content)
      when '.csv'
        #CSV sin header separado por punto y coma
        coordinates = common_converter(content, "\n", ";")
      when '.xlsx'
        #xlsx se pasa a csv
        xlsx = Roo::Excelx.new(filepath)
        #se pasa a csv y se limpia para quitar caracteres extras
        xlsx_content = xlsx.to_csv.gsub!("\"","")
        coordinates = common_converter(xlsx_content, "\n", ",")
      when '.tsv'
        #TSV sin header
        coordinates = common_converter(content, "\n", "\t")
      when '.gpx'
        coordinates = gpx_converter(content)
      end

    rescue => e
      p e
    end

    #data por defecto que lee el mapa implementado
    data = {
      "type": "FeatureCollection",
      "features": [{
        "type": "Feature",
        "geometry": {
          "type": "Polygon",
          "coordinates": [coordinates]
        },
        "properties": {}
      }]
    }
    data.to_json
  end

  private
    def kml_converter content
      #KML es xml XD
      coordinates = []
      kml_data = Hash.from_xml(content)
      kml_coordinates = kml_data["kml"]["Document"]["Folder"]["Placemark"]["Polygon"]["outerBoundaryIs"]["LinearRing"]["coordinates"].split("\n").reject(&:blank?)
      kml_coordinates.each do |kmlc|
        coord = kmlc.strip.split(",")
        coordinates << [coord[0].to_f, coord[1].to_f]
      end
      coordinates
    end

    def common_converter content, line_separator, column_separator
      coordinates = []
      content.split(line_separator).each do |coords|
        coord = coords.split(column_separator)
        coordinates << [coord[1].to_f,coord[0].to_f]
      end
      #debe cerrar el poligono al mismo punto inicial
      coordinates << coordinates.first
      coordinates
    end

    def gpx_converter content
      coordinates = []
      gpx_data = Hash.from_xml(content)
      gpx_data["gpx"]["wpt"].each do |coord|
        coordinates << [coord["lon"].to_f, coord["lat"].to_f]
      end
      coordinates
    end

end