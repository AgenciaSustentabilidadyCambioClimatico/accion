class DatoProductivoElementoAdherido < ApplicationRecord
  belongs_to :adhesion_elemento
  belongs_to :set_metas_accion
  belongs_to :dato_recolectado
  has_many :dato_levantado_mensuals
  #validates_uniqueness_of :adhesion_elemento_id, scope: [:dato_recolectado_id]
  validates :set_metas_accion_id, uniqueness: {scope: [:adhesion_elemento_id, :dato_recolectado_id]}

  #mount_uploader :archivo_excel, ArchivoExcelDatosProductivosElementoAdheridosUploader
  #mount_uploaders :archivos_evidencia, ArchivosEvidenciaDatosProductivosElementoAdheridosUploader

  def self.columnas_excel
    #["Rut Institución", "Nombre Institución", "Alcance", "Identificador Elemento Adherido", "Nombre Elemento a Certificar", "Tipo Elemento a Certificar", "Fecha de Adhesión", "Dirección Instalación Adherida", "Comuna Instalación Adherida", "Nombre Encargado APL Empresa / Contraparte", "Cargo Encargado APL Empresa / Contraparte", "Fono Encargado APL / Contraparte", "Mail Encargado APL/Contacto", "datos_productivos_elementos_adheridos_id", "Descripción Dato a Recolectar", "Descripción Verificador Dato a recolectar", "Unidades Compatibles", "Nombre archivo de evidencia", "Fecha Levantamiento", "Rut Levantador Datos en Terreno", "Unidad Declarada", "Mes", "Año", "Tipo de valor (mediana)", "Valor"]
    {
      rut_institucion: nil, #0
      nombre_institucion: nil, #1
      alcance: nil, #2
      identificador_elemento_adherido: nil, #3
      nombre_elemento_certificar: nil, #4
      tipo_elemento_certificar: nil, #5
      fecha_adhesion: nil, #6
      direccion_instalacion_adherida: nil, #7
      comuna_instalacion: nil, #8
      nombre_encargado: nil, #9
      cargo_encargado: nil, #10
      fono_encargado: nil, #11
      email_encargado: nil, #12
      id_datos_productivos_elementos_adheridos: nil, #13
      descripcion_dato_recolectar: nil, #14
      descripcion_verificar_dato_recolectar: nil, #15
      unidades_compatibles: nil, #16
      nombre_archivo_evidencia: nil, #17
      fecha_levantamiento: nil, #18
      rut_levantador_datos_terreno: nil, #19
      unidad_declarada: nil, #20
      #mes: nil, #21
      año: nil, #22
      tipo_valor: nil, #23
      valor: nil,#24
      id_dato_levantado_mensual: nil
    }
  end

  def self.generar_data (datos_productivos)
    
    data = []
    dominios = Hash.new
    #DZC varios ajustes para eliminar la dependencia de manifestación y asociarla a flujo
    # manifestacion = flujo.manifestacion_de_interes
    unless datos_productivos.blank?
      datos_productivos.each do |val|
        
        alcance = val.adhesion_elemento.alcance.nombre
        elemento_adherido = val.adhesion_elemento
        dr = val.dato_recolectado
        dominios = dominios.merge( {val.adhesion_elemento.alcance.nombre => dr.unidades_compatibles.reject(&:empty?)} )
        datos_levantados = val.dato_levantado_mensuals

        datos_levantados.each do |dato_levantado|
          data << {rut_institucion: elemento_adherido.fila[:rut_institucion].to_s, #0
              nombre_institucion: elemento_adherido.fila[:nombre_institucion].to_s, #1
              alcance: elemento_adherido.fila[:alcance].to_s, #2
              identificador_elemento_adherido: elemento_adherido.id, #3
              nombre_elemento_certificar: elemento_adherido.fila[:nombre_elemento].to_s, #4
              tipo_elemento_certificar: elemento_adherido.tipo, #5
              fecha_adhesion: elemento_adherido.fila[:fecha_adhesion].to_s, #6
              direccion_instalacion_adherida: elemento_adherido.fila[:direccion_instalacion].to_s, #7
              comuna_instalacion: elemento_adherido.fila[:comuna_instalacion].to_s, #8
              nombre_encargado: elemento_adherido.fila[:nombre_encargado].to_s, #9
              cargo_encargado: elemento_adherido.fila[:cargo_encargado].to_s, #10
              fono_encargado: elemento_adherido.fila[:fono_encargado].to_s, #11
              email_encargado: elemento_adherido.fila[:email_encargado].to_s, #12
              datos_productivos_elementos_adheridos_id: val.id, #13
              descripcion_dato_recolectar: dr.descripcion, #14
              descripcion_verificar_dato_recolectar: dr.medios_verificacion, #15
              unidades_compatibles: dr.unidades_compatibles_base, #16
              nombre_archivo_evidencia: dato_levantado.nombre_archivo_evidencia.present? ? dato_levantado.nombre_archivo_evidencia_identifier : "", #17
              fecha_levantamiento: dato_levantado.fecha_levantamiento.to_s, #18
              rut_levantador_datos_terreno: dato_levantado.rut_levantador.to_s, #19
              unidad_declarada: dato_levantado.unidad_declarada.to_s, #20
              #mes: dato_levantado.mes.to_s, #21
              año: dato_levantado.año.to_s, #22
              tipo_valor: dato_levantado.tipo_de_valor.to_s, #23
              valor: dato_levantado.valor.to_s, #24
              dato_levantado_mensual_id: dato_levantado.id.to_s
            }
        end
        (1..4 - datos_levantados.count).each do
          data << {rut_institucion: elemento_adherido.fila[:rut_institucion].to_s, #0
            nombre_institucion: elemento_adherido.fila[:nombre_institucion].to_s, #1
            alcance: elemento_adherido.fila[:alcance].to_s, #2
            identificador_elemento_adherido: elemento_adherido.id, #3
            nombre_elemento_certificar: elemento_adherido.fila[:nombre_elemento].to_s, #4
            tipo_elemento_certificar: elemento_adherido.tipo, #5
            fecha_adhesion: elemento_adherido.fila[:fecha_adhesion].to_s, #6
            direccion_instalacion_adherida: elemento_adherido.fila[:direccion_instalacion].to_s, #7
            comuna_instalacion: elemento_adherido.fila[:comuna_instalacion].to_s, #8
            nombre_encargado: elemento_adherido.fila[:nombre_encargado].to_s, #9
            cargo_encargado: elemento_adherido.fila[:cargo_encargado].to_s, #10
            fono_encargado: elemento_adherido.fila[:fono_encargado].to_s, #11
            email_encargado: elemento_adherido.fila[:email_encargado].to_s, #12
            datos_productivos_elementos_adheridos_id: val.id, #13
            descripcion_dato_recolectar: dr.descripcion, #14
            descripcion_verificar_dato_recolectar: dr.medios_verificacion, #15
            unidades_compatibles: dr.unidades_compatibles_base, #16
            nombre_archivo_evidencia: nil, #17
            fecha_levantamiento: nil, #18
            rut_levantador_datos_terreno: nil, #19
            unidad_declarada: nil, #20
            #mes: nil, #21
            año: nil, #22
            tipo_valor: nil, #23
            valor: nil #24
          }
        end
      end
    end
    unless data.blank?
      data = data.map {|i| i.map {|k,v| v }.compact}
      datos_generados = [data,dominios]
    else
      datos_generados = nil
    end
    datos_generados
  end

  def self.parsear_dato_productivo_elementoAdherido(archivo)
    data = []
    if archivo.present?
      header = DatoProductivoElementoAdherido.columnas_excel.map{|k,v| k}
      data = ExcelParser.new(archivo, header).tabulated
    end
    data
  end

  def self.data_dato_productivo_elementoAdherido(excell, archivos)
    errores = []
    datos_levantados = []
    data = parsear_dato_productivo_elementoAdherido(excell)
    archivo_correcto = true
    fecha_invalida = false
    campos_blancos = false
    unidad_invalida = false
    evidencia_invalida = false
    if data.size <= 0
      errores << ["Debe indicar al menos un dato productivo a los elementos adheridos"]
    else
      data.each_with_index do |dato, fila|
        vacio = dato[:id_dato_levantado_mensual].blank? && dato[:nombre_archivo_evidencia].blank? && dato[:fecha_levantamiento].blank? && dato[:rut_levantador_datos_terreno].blank? && dato[:unidad_declarada].blank? && dato[:año].blank? && dato[:tipo_valor].blank? && dato[:valor].blank?# && dato[:mes].blank?
        #Si no se ha editado el registo no crea, es decir si solo posee datos en blanco
        if vacio
          next
        else
          #Verifica si el registro existe o es nuevo              
          if dato[:id_dato_levantado_mensual].present?
            dato_levantado = DatoLevantadoMensual.find_or_create_by(id: dato[:id_dato_levantado_mensual])
          else
            d_p_e_a = DatoProductivoElementoAdherido.find(dato[:id_datos_productivos_elementos_adheridos])
            dato_levantado = d_p_e_a.dato_levantado_mensuals.new
          end
          #comienza a adjuntar los archivos al registro
          archivos_referenciados = nil
          if archivos.present?
            archivos.each do |archivo|
              if File.basename(archivo) == dato[:nombre_archivo_evidencia]
                archivos_referenciados = archivo
              end
            end
          end
          #Valida que no se asigne un dato nil
          if archivos_referenciados.present?  
            dato_levantado.nombre_archivo_evidencia = archivos_referenciados
          end
          dato_levantado.fecha_levantamiento = dato[:fecha_levantamiento]
          dato_levantado.rut_levantador = dato[:rut_levantador_datos_terreno]
          dato_levantado.unidad_declarada = dato[:unidad_declarada]
          dato_levantado.mes = 0 #parche para no modificar bd
          dato_levantado.año = dato[:año]
          dato_levantado.tipo_de_valor = dato[:tipo_valor]
          dato_levantado.valor = dato[:valor]
          if dato_levantado.valid?
            datos_levantados << dato_levantado
          else
            #if dato_levantado.errors[:mes].present?
            #  errores << "Se ha ingresado un mes invalido, para la fila #{fila+1}"
            #end
            if dato_levantado.errors[:año].present?
              errores << "Se ha ingresado un año invalido, para la fila #{fila+1}"
            end
            if dato_levantado.errors[:fecha_invalida].present?
              errores << "Se ha ingresado una fecha invalida, para la fila #{fila+1}"
            end
            if dato_levantado.errors[:unidades_compatibles].present?
              errores << "Se ha ingresado unidad no compatible, para la fila #{fila+1}"
            end
            if dato_levantado.errors[:archivo_invalido].present? || archivos_referenciados.nil? || dato_levantado.nombre_archivo_evidencia.nil?
              errores << "Archivo de evidencia incorrecto o no encontrado, para la fila #{fila+1}"
            end
            if archivos_referenciados.nil? || dato_levantado.nombre_archivo_evidencia.nil?
              errores << "Se ha ingresado campos en blanco, para la fila #{fila+1}"
            end
          end
        end
      end
    end
    
    # if fecha_invalida
    #   errores << "Se ha ingresado una fecha invalida, para la posición #{fila+1}"
    # end
    # if campos_blancos
    #   errores << "Se ha ingresado campos en blanco, para la posición #{fila+1}"
    # end
    # if unidad_invalida
    #   errores << "Se ha ingresado unidad no compatible, para la posición #{fila+1}"
    # end
    # if evidencia_invalida
    #   errores << "Archivo de evidencia incorrecto o no encontrado, para la posición #{fila+1}"
    # end
    #se guardan los datos de no existir error
    if errores.blank?
      datos_levantados.map {|dato| dato.save } 
    end
    errores
  end

end
