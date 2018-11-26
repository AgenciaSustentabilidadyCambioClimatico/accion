class EstablecimientoContribuyente < ApplicationRecord
  attr_accessor :rut_contribuyente, :nombre_contribuyente
  #se edita relacion, dado que un establecieminto posee 1 set_metas, por flujo.-
  has_many :ppf_metas_establecimiento

	belongs_to :contribuyente, optional: true
	belongs_to :pais, optional: true
	belongs_to :region, optional: true
	belongs_to :comuna, optional: true
	has_many :adhesion_elementos
	has_many :adhesiones, through: :adhesion_elementos

  validates :contribuyente, presence: true
	validates :direccion, presence: true
	#validates :ciudad, presence: true
	validates :region, presence: true
	validates :comuna, presence: true
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }, unless: -> {self.email.blank?}
  validates :telefono, format: { with: /\A[+]\d{2}[-, ]\d{9}\z/ }, unless: -> {self.telefono.blank?}

  serialize :fields_visibility

	validates_uniqueness_of :casa_matriz, scope: [:contribuyente_id], unless: proc{ self.casa_matriz.blank? }

  default_scope { where("fecha_eliminacion IS NULL") }

	def nombre_and_direccion
		if self.nombre_de_establecimiento.blank?
			return "#{self.direccion}"
		else
			return "#{self.nombre_de_establecimiento} - #{self.direccion}"
		end
	end

	def nombre_and_contribuyente
		if self.nombre_de_establecimiento.blank?
			return "#{self.contribuyente.razon_social}"
		else
			return "#{self.nombre_de_establecimiento} - #{self.contribuyente.razon_social}"
		end
	end

	def id_contibuyente_nombre
		if self.nombre_de_establecimiento.blank?
			return "#{self.id} - #{self.contribuyente.razon_social} - Sin nombre"
		else
			return "#{self.id} - #{self.contribuyente.razon_social} - #{self.nombre_de_establecimiento}"
		end
	end

	def nombre_direccion_and_contribuyente
		if self.nombre_de_establecimiento.blank?
			return "#{self.direccion} - #{self.contribuyente.razon_social}"
		else
			return "#{self.nombre_de_establecimiento} - #{self.direccion} - #{self.contribuyente.razon_social}"
		end
	end

	def nombre_direccion_comuna_and_contribuyente
		if self.nombre_de_establecimiento.blank?
			return "#{self.direccion} - #{self.contribuyente.razon_social}"
		else
			return "#{self.nombre_de_establecimiento} - #{self.direccion}, #{self.comuna.nombre} - #{self.contribuyente.razon_social}"
		end
	end
  	

	#Se considera adherido si el establecimiento se encuenta en una adhesion no finalziada.-
  def adherido_activo?
    flujos_asociados = Flujo.where(id: self.adhesiones.pluck('flujo_id')).where(terminado: false)
    flujos_asociados.count > 0
  end
  def adherido_inactivo?
    flujos_asociados = Flujo.where(id: self.adhesiones.pluck('flujo_id')).where(terminado: true)
    flujos_asociados.count > 0
  end

  # DZC 2018-11-07 19:32:18 
  def modifica_provincia_region_pais_acorde_a_comuna
  	unless self.comuna.blank?
	  	self.region_id = self.comuna.provincia.region.id
	  	self.pais_id = self.comuna.provincia.region.pais.id
	  	self.save
	  end
  end
end
