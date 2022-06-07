class Auditoria < ApplicationRecord

  # belongs_to :manifestacion_de_interes
  belongs_to :flujo
  has_many :auditoria_elementos, foreign_key: :auditoria_id, dependent: :destroy
  has_many :convocatoria, dependent: :destroy #DZC 2018-11-07 06:55:59 se agrega para las convocatorias de la ceremonia de certificación
  has_many :auditoria_niveles, dependent: :destroy

  accepts_nested_attributes_for :auditoria_elementos

  mount_uploaders :ceremonia_certificacion_archivo, ArchivoCeremoniaCertificacionAuditoriaUploader
  mount_uploader :archivo_revision, ArchivoRevisionAuditoriasUploader

  attr_accessor :archivo_auditorias, :archivos_informe, :archivos_evidencia, :archivo_carga_auditoria

  validate :valida_validacion, on: :validar_guardar

  validate :valid_extensions

  def valida_validacion #DZC validación de datos ingresados desde formulario
    se_valida=(self.con_validacion && (![1,2,3,4].includes?(self.autoria_elementos.where(validacion_aceptada: true).pluck(:estado))))
  end 

  def self.de_la_manif_de_interes(manif_de_interes)
    #DZC se ajusta por la desvinculación de la auditoria desde la manifiestación al flujo
    
    flujo = Flujo.find_by(manifestacion_de_interes_id: manif_de_interes.id)

    # ae = manif_de_interes.adhesion.adhesion_elementos.map{|ae| ae.id}
    # ae = [0]
    adh_elementos = flujo.adhesion.adhesion_elementos.order(id: :asc).pluck(:id)
    aud_ids = AuditoriaElemento.where(adhesion_elemento_id: adh_elementos).pluck(:auditoria_id)
    auditorias = Auditoria.where(id: aud_ids)
    # AuditoriaElemento.where(adhesion_elemento_id: ae).includes([:set_metas_accion, {adhesion_elemento: [{persona: [:user, :contribuyente]}, :alcance]}])
  end

  #DZC se obtienen label para reporte automatizado de avances
  def nombre_para_raa
    return "ID #{self.id} - #{(self.nombre.blank? ? 'Auditoria sin nombre': self.nombre)}"
  end

  def valid_extensions
    # DZC 2018-11-05 13:37:36 se modifica para el caso de que no se incluya alguno de los archivos
    extenciones = ["xlsx","xls"]
    extenciones_archivos = ["zip", "rar", "pdf", "jpg", "jpeg", "png"]
    unless self.archivo_carga_auditoria.blank?
      ext_carga = self.archivo_carga_auditoria.original_filename.split(".").last
      unless extenciones.include?(ext_carga)
        self.errors.add(:archivo_carga_auditoria, I18n.t('errors.messages.extension_whitelist_error', extension: ext_carga, allowed_types: extenciones))
      end
    end
    unless self.archivos_informe.blank?
      self.archivos_informe.each do |arch|
        ext_arch_informe = arch.original_filename.split(".").last
        unless extenciones_archivos.include?(ext_arch_informe)
          self.errors.add(:archivos_informe, I18n.t('errors.messages.extension_whitelist_error', extension: ext_arch_informe, allowed_types: extenciones_archivos))
        end
      end
    end
    unless self.archivos_evidencia.blank?
      self.archivos_evidencia.each do |arch|
        ext_arch_informe = arch.original_filename.split(".").last
        unless extenciones_archivos.include?(ext_arch_informe)
          self.errors.add(:archivos_evidencia, I18n.t('errors.messages.extension_whitelist_error', extension: ext_arch_informe, allowed_types: extenciones_archivos))
        end
      end
    end
  end

  def obtiene_porcentaje_avance(set_meta_accion, adhesion_elemento=nil)
    _auditoria_elementos = self.auditoria_elementos.where(set_metas_accion_id: set_meta_accion.id)
    _auditoria_elementos = _auditoria_elementos.where(adhesion_elemento_id: adhesion_elemento.id) if !adhesion_elemento.nil?
    porcentaje_avance = nil
    if _auditoria_elementos.present?
      total_auditorias_aplica = _auditoria_elementos.where(aplica: true).size.to_f
      porcentaje = (total_auditorias_aplica > 0)? (total_auditorias_aplica/_auditoria_elementos.length.to_f).to_f : 0.to_f
      porcentaje_avance = (porcentaje*100.0)
    end
    porcentaje_avance
  end

end
