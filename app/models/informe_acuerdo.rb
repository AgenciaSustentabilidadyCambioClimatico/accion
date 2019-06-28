class InformeAcuerdo < ApplicationRecord
  belongs_to :manifestacion_de_interes

  # validates :con_extension, presence: true, unless: -> { self.tarea_codigo == Tarea::COD_APL_018 || self.solo_guarda_archivos}
  validates :plazo_maximo_adhesion, presence: true#, on: :update #, unless: -> { (self.plazo_maximo_adhesion.blank? ? (self.plazo_maximo_adhesion = 0) : false }
  validates :plazo_finalizacion_implementacion, presence: true#, on: :update
  validates :plazo_maximo_neto, presence: true#, on: :update
  validate :plazos_correctos?, on: :update, unless: ->{self.accion.present? && self.accion == "guardar_archivos_anexos_posteriores_firmas"} #DZC 2018-11-15 14:44:46 valida que los plazos contengan la lógica entre ellos, salvo que solo se esté guardando el archivo de evidencia obligatorio
  
  # DZC 2019-06-11 17:56:58 se agrega para validar :con_extension
  validate :extension_valida?, unless: -> { self.tarea_codigo == Tarea::COD_APL_018 || self.solo_guarda_archivos}

  mount_uploaders :archivos_anexos, ArchivosAnexosInformeAcuerdosUploader
  mount_uploaders :archivos_anexos_posteriores_firmas, ArchivosAnexosPosterioresFirmasInformeAcuerdosUploader #DZC se agrega para tarea APL-023

  # DZC 2018-11-02 20:08:24 valida que los archivos subidos se correspondan con el tipo de archivo 
  # DZC 2018-11-08 13:54:26 evita la validación de la existencia de los archivos de evidencia en la APL-018
  validates :archivos_anexos_posteriores_firmas, presence: true, on: :update, unless: -> {self.tarea_codigo == Tarea::COD_APL_018} 

  enum tipo_acuerdo: [:simultáneo, :asincrónico]
  enum mecanismo_implementacion_palabras_claves: [:tipo_acuerdo, :plazo_maximo_adhesion, :plazo_finalizacion_implementacion]
  enum mecanismo_evaluacion_palabras_claves: [:plazo_maximo, :plazo_maximo_neto, :adhesiones, :con_validacion]

  # DZC 2018-11-12 10:44:17 se agrega variable archivos_por_eliminar
  attr_accessor :fecha_firma, :fecha_plazo_maximo_adhesion, :fecha_plazo_finalizacion_implementacion, :fecha_plazo_maximo, :fecha_plazo_maximo_neto, :auditorias, :tarea_codigo, :archivos_por_eliminar, :accion

  # DZC 2019-06-11 17:04:55 se agrega para evitar validación en solo guardado de archivos
  attr_accessor :solo_guarda_archivos

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

  # DZC 2019-06-11 17:58:51 se agrega para validar existencia de atributo :con_extension
  def extension_valida?
    self.con_extension.present? || [true,false].include?(self.con_extension)
  end

  def plazos_correctos? #DZC MODIFICAR PREGUNTANDO VALIDACIONES DE PENDIENTES
    
    flujo = self.manifestacion_de_interes.flujo
    # binding.pry
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
      # binding.pry
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

  def _a_datos(auditorias)
    
    datos = self.attributes
    datos.each{ |k,v| datos[k] = "" if v.nil? }
    datos["archivos_anexos"] = datos["archivos_anexos"].join(",")
    datos["auditorias"] = auditorias.map{|aud| {"nombre" => aud.nombre}}
    datos
  end

  #DZC se agrega solo para cargar archivos anexos posteriores a firma en APL-023
  def _a_datos_archivos_anexos_posteriores_firmas
    datos = self.attributes
    datos.each{ |k,v| datos[k] = "" if v.nil? }
    datos["archivos_anexos_posteriores_firmas"] = datos["archivos_anexos_posteriores_firmas"].join(",")
    datos
  end
    
  #DZC calcula fechas
  def calcula_fechas
    self.calcula_fecha_firma
    self.calcula_fecha_plazo_maximo_adhesion
    self.calcula_fecha_plazo_finalizacion_implementacion
    self.calcula_fecha_plazo_maximo
    self.calcula_fecha_plazo_maximo_neto
  end

  def calcula_fecha_firma
    self.fecha_firma = self.manifestacion_de_interes.firma_fecha
  end

  def calcula_fecha_plazo_maximo_adhesion(meses=self.plazo_maximo_adhesion)
    
    meses = meses.blank? ? 0 : meses
    self.fecha_plazo_maximo_adhesion = self.calcula_fecha_firma + meses.months
  end

  #DZC depende del tipo_acuerdo
  def calcula_fecha_plazo_finalizacion_implementacion(meses=self.plazo_finalizacion_implementacion)
    
    meses = meses.blank? ? 0 : meses
    if self.tipo_acuerdo == :simultáneo.to_s
      self.fecha_plazo_finalizacion_implementacion = self.calcula_fecha_firma + meses.months
    else
      # DZC 2018-11-07 11:31:47 se previene posibilidad del que plazo_maximo_adhesion sea nil
      # DZC 2018-11-07 11:37:45 TODO: precaver posibilidad de que al adherirse a un standar los campos asociados a plazos en informe vengan nil
      self.fecha_plazo_finalizacion_implementacion = self.calcula_fecha_firma + ((self.plazo_maximo_adhesion.blank? ? 0 : self.plazo_maximo_adhesion) + meses).months
    end
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

end
