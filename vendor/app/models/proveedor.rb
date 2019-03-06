class Proveedor < ApplicationRecord
	belongs_to :contribuyente#, optional: true
	belongs_to :tipo_instrumento, optional: true
	belongs_to :materia_sustancia, optional: true
	belongs_to :clasificacion, optional: true
	belongs_to :alcance, optional: true

	has_many :proveedor_tipo_proveedores, foreign_key: :proveedor_id, dependent: :destroy
	accepts_nested_attributes_for :proveedor_tipo_proveedores, allow_destroy: true

	validates :contribuyente_id, presence: true

	validate :debe_tener_al_menos_un_tipo_de_proveedor
  validate :debe_indicar_datos_contribuyente

  attr_accessor :rut_contribuyente, :nombre_contribuyente

	def initialize(attributes = {})
    #rut_contribuyente = attributes[:rut_contribuyente]
    #attributes.delete(:rut_contribuyente)
    #nombre_contribuyente = attributes[:nombre_contribuyente]
    #attributes.delete(:nombre_contribuyente)

		super(attributes)

   # self.rut_contribuyente = rut_contribuyente
   # self.nombre_contribuyente = nombre_contribuyente

		# Agregamos un tipo de proveedor si no viene ninguno
    if self.proveedor_tipo_proveedores.size == 0
      self.proveedor_tipo_proveedores.build
    else
    	# Si viene, los agrupamos por ID y objeto
    	ptp_array = []
    	self.proveedor_tipo_proveedores.each do |ptp|
    		ptp_array << [ptp.tipo_proveedor_id,ptp]
    	end
    	# Reasignamos el array filtrando repetidos
    	self.proveedor_tipo_proveedores = ptp_array.uniq{|ptpi|ptpi.first}.map{|m|m.last}
    end
	end

  def debe_tener_al_menos_un_tipo_de_proveedor
  	if proveedor_tipo_proveedores.empty?
    	errors.add("proveedor_tipo_proveedores.tipo_proveedor_id", 'Debe indicar al menos un tipo de proveedor')
    end
  end

  def debe_indicar_datos_contribuyente
    if self.contribuyente_id.blank?||self.rut_contribuyente.blank?
      errors.add(:rut_contribuyente, "Indique el RUT de la institución")
    end
    if self.contribuyente_id.blank?||self.nombre_contribuyente.blank?
      errors.add(:nombre_contribuyente, "Indique el nombre de la institución")
    end
  end

  #DZC calcula evaluación promedio del proveedor
  def calcula_evaluacion
    evaluaciones=EncuestaUserRespuesta.where(institucion_proveedor_id: self.contribuyente_id, pregunta_id: 2).all #DZC se asume que la pregunta id 2 será la correspondiente a la evaluación
    promedio=0
    unless evaluaciones.size == 0
      evaluaciones.map do |e|
         promedio+=e.respuesta.to_i
      end
      promedio/=evaluaciones.size
    end
    self.evaluacion = promedio
  end

end