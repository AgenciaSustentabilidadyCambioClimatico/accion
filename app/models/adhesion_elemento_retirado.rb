class AdhesionElementoRetirado < ApplicationRecord

  mount_uploader :archivo_adhesion, ArchivoAdhesionYDocumentacionAdhesionesUploader
  mount_uploader :archivo_respaldo, ArchivoAdhesionYDocumentacionAdhesionesUploader
  mount_uploader :archivo_retiro, ArchivoAdhesionYDocumentacionAdhesionesUploader

  belongs_to :adhesion
  belongs_to :persona, optional: true
  belongs_to :alcance, optional: true
  belongs_to :establecimiento_contribuyente, optional: true
  belongs_to :maquinaria, optional: true
  belongs_to :otro, optional: true

  has_many :dato_productivo_elemento_adheridos
  has_many :certificacion_adhesion_historicos, dependent: :destroy

  serialize :fila

	validates :archivo_retiro, presence: true

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
    auditorias = auditoria_especifica.blank? ? Auditoria.where(flujo_id: flujo_id) : [auditoria_especifica]
    auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias.pluck(:id), adhesion_elemento_id: self.id)

    auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true)
    total_auditorias_elementos_aplica = auditoria_elementos.where(aplica: true).size.to_f
    
    if con_certificacion
      auditorias_cumple_aplica = auditorias_cumple_aplica.select do |aud_elem|
        
        if aud_elem.auditoria.con_validacion == true
          (aud_elem[:validacion_aceptada] == true && aud_elem[:aprobacion_fecha].present?)
        else
          aud_elem[:aprobacion_fecha].present?
        end
      end
    end
    total_auditorias_cumple_aplica = auditorias_cumple_aplica.size.to_f 
    porcentaje = (total_auditorias_elementos_aplica > 0)? (total_auditorias_cumple_aplica/total_auditorias_elementos_aplica).to_f : 0.to_f
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
end
