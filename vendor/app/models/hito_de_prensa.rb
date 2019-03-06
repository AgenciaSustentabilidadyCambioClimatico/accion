class HitoDePrensa < ApplicationRecord
	self.table_name = :hitos_de_prensa
	attr_accessor :filter_mode
	# belongs_to :flujo
	belongs_to :tipo_de_medio
	has_many :hito_de_prensa_instrumentos, foreign_key: :hitos_de_prensa_id, dependent: :destroy 
	accepts_nested_attributes_for :hito_de_prensa_instrumentos, :allow_destroy => true, reject_if: :all_blank
	has_many :hito_de_prensa_archivos, foreign_key: :hitos_de_prensa_id, dependent: :destroy 
	accepts_nested_attributes_for :hito_de_prensa_archivos, :allow_destroy => true, reject_if: :all_blank
	has_many :hito_de_prensa_responsables, foreign_key: :hitos_de_prensa_id, dependent: :destroy 
	accepts_nested_attributes_for :hito_de_prensa_responsables, :allow_destroy => true, reject_if: :all_blank
	
	validates :nombre, presence: true
	validates :medio, presence: true, unless: proc{self.filter_mode==true}
	validates :tipo_de_medio_id, presence: true, unless: proc{self.filter_mode==true}
	validates :enlace, presence: true, http_url: true, unless: proc{self.filter_mode==true}, if: proc{self.enlace.present?}
	#validates :observaciones, presence: true, unless: proc{self.filter_mode==true}
	validates :fecha_publicacion, presence: true, unless: proc{self.filter_mode==true}
	validates_uniqueness_of :enlace, unless: proc{self.filter_mode==true || self.enlace.blank? }

	validate :filter_data, if: proc{self.filter_mode==true}

	validate :fecha_publicacion_mayor_hoy

  def fecha_publicacion_mayor_hoy
    if fecha_publicacion.present? && fecha_publicacion > Date.today
      errors.add(:fecha_publicacion, "Fecha no puede ser superior a la fecha actual")
    end
  end 

	def filter_data
	end
end