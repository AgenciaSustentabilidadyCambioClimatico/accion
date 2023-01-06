class Institucion < ApplicationRecord
	attr_accessor :filter_mode, :es_para_seleccion
  self.table_name = :contribuyentes
	has_many :dato_anual_contribuyentes, -> { distinct includes :tipo_contribuyente }, foreign_key: :contribuyente_id
	has_many :establecimiento_contribuyentes, foreign_key: :contribuyente_id
	has_many :actividad_economica_contribuyentes, -> { distinct includes :actividad_economica }, foreign_key: :contribuyente_id
	has_many :proyecto
	accepts_nested_attributes_for :actividad_economica_contribuyentes, :allow_destroy => true, reject_if: :all_blank
	accepts_nested_attributes_for :establecimiento_contribuyentes, :allow_destroy => true, reject_if: :all_blank
	accepts_nested_attributes_for :dato_anual_contribuyentes, :allow_destroy => true, reject_if: :all_blank

	validates :rut, presence: true, unless: proc{self.filter_mode==true}
	validates :dv, presence: true, unless: proc{self.filter_mode==true}
	validates :razon_social, presence: true, unless: proc{self.filter_mode==true}
	validates_uniqueness_of :rut, unless: proc{self.filter_mode==true}

	validate :filter_data, if: proc{self.filter_mode==true}
	validate :rut_dv

	alias_attribute :nombre, :razon_social

	def filter_data
		if (self.rut.blank? && self.dv.blank? && self.razon_social.blank?)
			errors.add(:rut, "Indique un RUT")
			errors.add(:dv, "Indique el dígito verificador del RUT")
			errors.add(:razon_social, "Indique la razón social")
		elsif (self.dv.blank? && ! self.rut.blank?)
			errors.add(:dv, "Indique el dígito verificador del RUT")
		elsif (self.rut.blank? && ! self.dv.blank?)
			errors.add(:rut, "Indique el RUT del dígito verificador")
		elsif (! self.razon_social.blank? && self.razon_social.size < 4)
			errors.add(:razon_social, "Indique escribir un nombre igual o mayor a 4 caracteres")
		end
	end

	def rut_dv
		if ( ! self.rut.blank? && ! self.dv.blank? )
			unless "#{self.rut}-#{self.dv}".rut_valid?
				errors.add(:rut, "Indique un RUT válido")
				errors.add(:dv, "El dígito verificador no corresponde al RUT ingresado")
			end
		end
	end

end
