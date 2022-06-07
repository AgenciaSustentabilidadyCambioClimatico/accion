class EstandarSetMetasAccion < ApplicationRecord
  belongs_to :estandar_homologacion
  belongs_to :accion
  belongs_to :materia_sustancia, optional: true
  belongs_to :meta, optional: true, foreign_key: :meta_id, class_name: :Clasificacion
  belongs_to :alcance, optional: true
  belongs_to :estandar_nivel, optional: true

  attr_accessor :obligatorio_para_nivel
  
  validates :accion_id, presence: true
  validates :meta_id, presence: true
  validates :alcance_id, presence: true
  validates :descripcion_accion, presence: true
  #validates :detalle_medio_verificacion, presence: true

  before_save :reiniciar_estandar_nivel
  after_save :obligatorio_para_nivel_a_estandar_nivel

  def reiniciar_estandar_nivel
    self.estandar_nivel_id = nil
  end

  def obligatorio_para_nivel_a_estandar_nivel
    if !self.obligatorio_para_nivel.blank?
      en = EstandarNivel.where(estandar_homologacion_id: self.estandar_homologacion_id, numero: self.obligatorio_para_nivel).first
      self.update_column(:estandar_nivel_id, en.id)
    end
  end
end
