class DatoRecolectado < ApplicationRecord
  attr :secciones_observadas_pertinencia_factibilidad

  has_one :materia_rubro_dato_relacion
  has_many :dato_productivo_elemento_adheridos

  validates :nombre, presence: true
  validates :descripcion, presence: true
  validates :cpc, presence: true
  validates :medios_verificacion, presence: true
  validates :unidad_base, presence: true
  validates :unidades_compatibles, presence: true

  serialize :unidades_compatibles

  def self.unidades_extras
    [
      {name: 'KILOWATT-HORA', prefix: 'Kwh', compatibles: ['Kwh', 'Wh', 'W', 'J']},
      {name: 'WATT-HORA', prefix: 'Wh', compatibles: ['Wh', 'Kwh', 'W', 'J']},
    ]
  end


  def self.compatibles unidad_b
    td = []
    unidades = Unit.definitions.values
    if unidad_b.present?
      begin
        unidad = unidad_b.to_unit
        unidades.each_with_index do |val, index|
          if !val.prefix? && val.display_name.to_unit =~ unidad
            td.push(val)
          end
        end
        td = td.map{|k| [k.name.gsub(/[<>]/, '').upcase, k.display_name] }
      rescue => e

      end
      unidad_extra = self.unidades_extras.select{|u| u[:prefix] == unidad_b}.first
      if !unidad_extra.blank?
        unidad_extra[:compatibles].each do |prefix_extra|
          td_custom = nil
          #primero compatibles de customizacion
          compatible_extra = self.unidades_extras.select{|u| u[:prefix].to_s == prefix_extra.to_s}.first
          td_custom = [compatible_extra[:name], compatible_extra[:prefix]] if !compatible_extra.blank?
          #despues verifico si tambien es de la gema
          unidad_custom = unidades.select{|u| u.display_name == prefix_extra}.first
          if !unidad_custom.blank?
            td_custom = [unidad_custom.name.gsub(/[<>]/, '').upcase, unidad_custom.display_name]
          end
          td << td_custom if !td_custom.nil?
        end
      end
    end
    td
  end

  def unidades_compatibles_base
    compatibles = self.unidades_compatibles.reject(&:empty?).to_sentence
    "#{self.unidad_base} / #{compatibles}"
  end
end
