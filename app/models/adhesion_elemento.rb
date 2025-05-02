class AdhesionElemento < ApplicationRecord

  mount_uploader :archivo_adhesion, ArchivoAdhesionYDocumentacionAdhesionesUploader
  mount_uploader :archivo_respaldo, ArchivoAdhesionYDocumentacionAdhesionesUploader

  #belongs_to :adhesion
  belongs_to :persona, optional: true
  belongs_to :alcance, optional: true
  belongs_to :establecimiento_contribuyente, optional: true
  belongs_to :maquinaria, optional: true
  belongs_to :otro, optional: true
  belongs_to :adhesion_externa, class_name: 'Adhesion', foreign_key: 'adhesion_externa_id', optional: true

  has_many :dato_productivo_elemento_adheridos
  has_many :certificacion_adhesion_historicos, dependent: :destroy

  serialize :fila

  def adhesion
    Adhesion.unscoped.find(self.adhesion_id)
  end

  # DZC 2019-07-05 15:56:17 se corrige comportamiento inesperado en construcción de archivo de formato de datos productivos
  def tipo
    if self.establecimiento_contribuyente_id.present?
      "Establecimiento"
    elsif self.maquinaria_id.present?
      "Maquinaria"
    elsif self.otro_id.present?
      "Otro"
    else
      "No encontrado"
    end              
  end

  #DZC se obtienen label para reporte automatizado de avances
  def nombre_para_raa
    
    tipo = self.alcance.nombre unless self.alcance.nombre.blank?
    case tipo
    when 'Organización'
      nombre = self.adhesion.flujo.contribuyente.razon_social.blank? ? '' : self.adhesion.flujo.contribuyente.razon_social
    when 'Establecimiento'
      nombre = self.establecimiento_contribuyente.nombre_de_establecimiento.blank? ? '' : self.establecimiento_contribuyente.nombre_de_establecimiento
    when 'Maquinaria'
      nombre = self.maquinaria.nombre_maquinaria.blank? ? '' : self.maquinaria.nombre_maquinaria
    end
    return "ID #{self.id} - #{self.persona.contribuyente.razon_social} - #{self.nombre_segun_alcance}"
  end

  def nombre_segun_alcance
    tipo = self.alcance.nombre unless self.alcance.nombre.blank?
    case tipo
    when 'Organización'
      nombre = self.persona.contribuyente.razon_social.blank? ? 'Contribuyente - sin razon solcial' : self.persona.contribuyente.razon_social
    when 'Establecimiento'
      nombre = self.establecimiento_contribuyente.nombre_de_establecimiento.blank? ? 'Establecimiento - sin nombre' : self.establecimiento_contribuyente.nombre_de_establecimiento
    when 'Maquinaria'
      nombre = self.maquinaria.nombre_maquinaria.blank? ? 'Maquinaria - sin nombre' : self.maquinaria.nombre_maquinaria
    else
      nombre = self.otro.blank? ? 'Otro - sin nombre' : self.otro.nombre      
    end
    return nombre unless tipo.blank?   
  end

  def dir_segun_alcance
    dir = ""
    if self.alcance_id == Alcance::ORGANIZACION
      ec_elem = Contribuyente.find_by(rut: self.fila["rut_institucion"].split('-').first).direccion_principal
      dir = {direccion: ec_elem.direccion, comuna: ec_elem.comuna.nombre}
    else
      dir = {direccion: self.fila[:direccion_instalacion], comuna: self.fila[:comuna_instalacion]}
    end
    dir 
  end

  def otro_dato
    otro_dato = ""
    if self.alcance_id == Alcance::MAQUINARIA
      otro_dato = [self.maquinaria.numero_serie,self.maquinaria.patente].join("/")
    elsif self.alcance_id == Alcance::PRODUCTO
      otro_dato = self.otro.identificador_unico
    elsif self.alcance_id == Alcance::ESTABLECIMIENTO
      ec_elem = self.establecimiento_contribuyente
      otro_dato = [ec_elem.direccion,ec_elem.comuna.nombre,ec_elem.comuna.provincia.region.nombre].join(", ")
    else
      rut_institucion = self.fila["rut_institucion"]
      if rut_institucion.present?
        ec_elem = Contribuyente.find_by(rut: rut_institucion.split('-').first).direccion_principal
        otro_dato = [ec_elem.direccion, ec_elem.comuna.nombre, ec_elem.comuna.provincia.region.nombre].join(", ") if ec_elem
      else
        otro_dato = "Datos incompletos"
      end
    end
    otro_dato
  end

  #DZC calucula el porcentaje de cumplimiento 
  # DZC 2018-11-13 11:27:19 se modifica para correcta aplicación de filtros de auditoría y elemento adherido
  # DZC 2018-11-14 16:47:00 se traspasa la primera parte del código al método calcula_porcentaje_cumplimiento
  def obtiene_procentaje_cumplimiento(auditoria_especifica=nil)
    
    # flujo_id = self.adhesion.flujo.id
    # # DZC 2018-11-13 11:22:13 se modifica para correcta aplicación del filtro
    # auditorias = auditoria_especifica.blank? ? Auditoria.where(flujo_id: flujo_id) : [auditoria_especifica]
    # auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias.pluck(:id), adhesion_elemento_id: self.id)
    # total_auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true).size.to_f
    # total_auditorias_aplica = auditoria_elementos.where(aplica: true).size.to_f
    # porcentaje = (total_auditorias_aplica > 0)? (total_auditorias_cumple_aplica/total_auditorias_aplica).to_f : 0.to_f
    porcentaje = self.calcula_porcentaje_cumplimiento(auditoria_especifica)
    porcentaje_cumplimiento =  "#{(porcentaje*100).round(2)}%"
  end

  # DZC 2018-11-14 16:46:33 se agrega para vista de elementos certificados
  def calcula_porcentaje_cumplimiento(auditoria_especifica=nil, con_certificacion=false)
    flujo_id = self.adhesion.flujo.id
    # DZC 2018-11-13 11:22:13 se modifica para correcta aplicación del filtro
    auditorias = auditoria_especifica.blank? ? Auditoria.where(flujo_id: flujo_id).pluck(:id) : [auditoria_especifica.id]
    auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias, adhesion_elemento_id: self.id)

    auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true)
    total_auditorias_elementos_aplica = auditoria_elementos.where(aplica: true).size.to_f
    
    if con_certificacion
      auditorias_cumple_aplica = auditorias_cumple_aplica.select do |aud_elem|
        
        if aud_elem.auditoria.con_validacion
          validado = true
          auditorias.each do |aud_id|
            aud_val = AuditoriaValidacion.find_by(auditoria_id:aud_id)
            if !aud_val.nil? && aud_val.validaciones.has_key?(self.id.to_s) && !aud_val.validaciones[self.id.to_s][:estado_valor]
              validado = false 
              break
            end
          end
          validado && aud_elem[:aprobacion_fecha].present?
        else
          aud_elem[:aprobacion_fecha].present?
        end
      end
    end
    total_auditorias_cumple_aplica = auditorias_cumple_aplica.size.to_f 
    porcentaje = (total_auditorias_elementos_aplica > 0)? (total_auditorias_cumple_aplica/total_auditorias_elementos_aplica).to_f : 0.to_f
  end


  def cumple_nivel(auditoria)
    auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditoria.id, adhesion_elemento_id: self.id)

    auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true)
    #filtro solo los que esten certificados
    auditorias_cumple_aplica = auditorias_cumple_aplica.select do |aud_elem|
      if aud_elem.auditoria.con_validacion
        aud_val = AuditoriaValidacion.find_by(auditoria_id:auditoria.id)
        aud_val.validaciones.has_key?(self.id.to_s) && aud_val.validaciones[self.id.to_s][:estado_valor] && aud_elem[:aprobacion_fecha].present?
      else
        aud_elem[:aprobacion_fecha].present?
      end
    end
    estandares_ref_ids = auditorias_cumple_aplica.select{|aca| aca.set_metas_accion.modelo_referencia == "EstandarSetMetasAccion" }.map{|aca| aca.set_metas_accion.id_referencia }
    total_auditorias_elementos_aplica = auditoria_elementos.where(aplica: true).size.to_f

    if total_auditorias_elementos_aplica > 0

      auditoria.auditoria_niveles.includes(:estandar_nivel).order("estandar_niveles.porcentaje DESC").each do |aud_nivel|
        set_metas_acciones_ids = EstandarSetMetasAccion.where(estandar_nivel_id: aud_nivel.estandar_nivel_id).pluck(:id)
        #si no esta vacio es porque hay acciones obligatorias para el nivel
        if !set_metas_acciones_ids.blank?
          if !(set_metas_acciones_ids - estandares_ref_ids).blank?
            #si no estan todas las obligatorias cumplidas, siguiente nivel, este no se cumple
            next
          end
        end 

        #debo calcular los puntos en base a su set-meta-accion de estandar
        estandar_nivel = aud_nivel.estandar_nivel
        estandar_set_metas_acciones = estandar_nivel.estandar_homologacion.estandar_set_metas_acciones
        total_puntaje_estandares = estandar_set_metas_acciones.sum{|esma| esma.puntaje}
        puntaje_obtendio_auditoria = estandar_set_metas_acciones.where(id: estandares_ref_ids).sum{|esma| esma.puntaje}
        porcentaje = (puntaje_obtendio_auditoria.to_f/total_puntaje_estandares.to_f) * 100

        return aud_nivel if porcentaje  >= estandar_nivel.porcentaje.to_f
      end
    end
    return nil
  end

  def ultima_auditoria_elemento_cumplida
    auditoria_elems = AuditoriaElemento.where(adhesion_elemento_id: self.id, cumple: true, aplica: true)
                      .where.not(aprobacion_fecha: nil)
                      .order(aprobacion_fecha: :desc)
    auditoria_elems.each do |aud_elem|
      if aud_elem.auditoria.con_validacion == true
        if aud_elem.validacion_aceptada
          return aud_elem
        end
      else
        return aud_elem
      end
    end
  end

  def fecha_certificacion
    self.ultima_auditoria_elemento_cumplida.aprobacion_fecha
  end

  def vigencia_certificacion(nivel_plazo=nil, fecha=self.fecha_certificacion)
    plazo = 0
    if nivel_plazo.to_i > 0 
      plazo = nivel_plazo.to_i
    else
      plazo = self.ultima_auditoria_elemento_cumplida.auditoria.plazo.to_i
      if plazo == 0
        plazo = InformeAcuerdo.where(manifestacion_de_interes_id: self.ultima_auditoria_elemento_cumplida.auditoria.flujo.manifestacion_de_interes_id).last.vigencia_certificacion_final.to_i
      end
    end
    (fecha+plazo.years)
  end

  def nombre_del_elemento #APL:033
    tipo = self.alcance.nombre unless self.alcance.nombre.blank?
    case tipo
    when 'Organización'
      nombre = self.adhesion.flujo.contribuyente.razon_social.blank? ? 'Organización - sin nombre' : "Organización - #{self.adhesion.flujo.contribuyente.razon_social}"
    when 'Establecimiento'
      texto = self.establecimiento_contribuyente.nombre_direccion_comuna_and_contribuyente
      nombre = self.establecimiento_contribuyente.nombre_de_establecimiento.blank? ? "Establecimiento - sin nombre #{texto}" : "Establecimiento - #{texto}"
    when 'Maquinaria'
      nombre = self.maquinaria.nombre_maquinaria.blank? ? 'Maquinaria - sin nombre' : "Maquinaria - #{self.maquinaria.nombre_maquinaria}"
    else
      nombre = self.otro.blank? ? "#{self.alcance.nombre} - sin nombre" : "#{self.alcance.nombre} - #{self.otro.nombre}"      
    end
  end

  def nombre_del_elemento_v2 #APL:033
    tipo = self.alcance.nombre unless self.alcance.nombre.blank?
    self.fila[:nombre_elemento].blank? ? "#{tipo} - sin nombre" : "#{tipo} - #{self.fila[:nombre_elemento]}"
  end

end
