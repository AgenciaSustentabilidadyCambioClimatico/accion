class ActividadPorLinea < ApplicationRecord
	enum tipo_permiso: [ :obligatoria, :permitida, :no_permitida, :nueva ]
	enum tipo_actividad: [ :tipo_a, :tipo_b, :no_aplica ]

	belongs_to :actividad
	belongs_to :linea, class_name: :TipoInstrumento, foreign_key: :tipo_instrumento_id

	validates :actividad_id, presence: true
	validates :tipo_instrumento_id, presence: true
	validates :tipo_permiso, presence: true
	#validates :tipo_actividad, presence: true
	#, inclusion: { in: %w( obligatoria permitida no_permitida ), message: "El tipo %{value} no es un permiso válido" }


	def initialize(*)
    super
  rescue ArgumentError
    raise if valid?
  end

	def self.permisos
		self.tipo_permisos.map{|n,i|[I18n.t(n.to_sym),n]}
	end

	def self.actividades
		self.tipo_actividades.map{|n,i|[I18n.t(n.to_sym),n]}
	end
	
	#PERMISO_OBLIGATORIA	= 0
	#PERMISO_PERMITIDA		= 1
	#PERMISO_NO_PERMITIDA	= 2
	#NUEVA					= 3
end