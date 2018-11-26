class Accion < ApplicationRecord
	belongs_to :meta, optional: true, foreign_key: :meta_id, class_name: :Clasificacion

	has_many :accion_clasificaciones, foreign_key: :accion_id, dependent: :destroy
	accepts_nested_attributes_for :accion_clasificaciones, allow_destroy: true

	has_many :accion_relacionadas, foreign_key: :accion_id, dependent: :destroy
	accepts_nested_attributes_for :accion_relacionadas, allow_destroy: true#, reject_if: :all_blank

	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates :debe_asociar_materia_sustancia, presence: true, unless: -> { debe_asociar_materia_sustancia == false }
	validates :medio_de_verificacion_generico, presence: true
  validates :meta_id, presence: true, if: -> { debe_asociar_materia_sustancia == false }
  after_save :update_accion_relacionadas

	def initialize(attributes = {})
		super(attributes)
		filtrar_nested_attributes
	end

	def update(attributes)
		super(attributes)
		filtrar_nested_attributes
	end

	def update_accion_relacionadas
		accion_relacionada_ids = self.accion_relacionadas.map{|m|m.accion_relacionada_id}
		condicion_final = accion_relacionada_ids.size == 0 ? "" : "AND accion_id NOT IN (#{accion_relacionada_ids.join(',')})"
		ActiveRecord::Base.connection.query(
			"
				DELETE FROM accion_relacionadas 
					WHERE accion_relacionada_id = #{self.id} 
					#{condicion_final}
			"
		);
		self.accion_relacionadas.each do |ar|
			attr_= { accion_id: ar.accion_relacionada_id, accion_relacionada_id: ar.accion_id }
			a=AccionRelacionada.where(attr_).first
			if a.nil?
				b = AccionRelacionada.new(attr_)
				b.descripcion = ar.descripcion
				b.save
			else
				a.descripcion = ar.descripcion
				a.save
			end
		end	
	end

	def self.descritas
		descripcion = {}
		Accion.all.each do |accion|
			descripcion[accion.id] = {
				id: accion.id, # redudante, pero lo necesito para el filtro por clasificación
				nombre: accion.nombre,
				descripcion: accion.descripcion,
				meta_id: accion.meta_id,
				debe_asociar_materia_sustancia: accion.debe_asociar_materia_sustancia,
				medio_de_verificacion_generico: accion.medio_de_verificacion_generico
			}
		end
		descripcion
	end


	private
	def filtrar_nested_attributes
		# => ACCION_CLASIFICACION
		# Agregamos un tipo de proveedor si no viene ninguno
    if self.accion_clasificaciones.size == 0
      self.accion_clasificaciones.build
    else
    	# Si viene, los agrupamos por ID y objeto
    	ac_array = []
    	self.accion_clasificaciones.each do |ac|
    		ac_array << [ac.clasificacion_id,ac]
    	end
    	# Reasignamos el array filtrando repetidos
    	self.accion_clasificaciones = ac_array.uniq{|aci|aci.first}.map{|m|m.last}
    end
=begin
    # => ACCION RELACIONADAS
    # Agregamos un tipo de proveedor si no viene ninguno
    if self.accion_relacionadas.size > 0
    	# Si viene, los agrupamos por ID y objeto
    	ar_array = []
    	self.accion_relacionadas.each do |ar|
    		ar_array << [ar.accion_relacionada_id,ar]
    	end
    	# Reasignamos el array filtrando repetidos
    	self.accion_relacionadas = ar_array.uniq{|ari|ari.first}.map{|m|m.last} if ar_array.size > 0
    end
=end
	end

end