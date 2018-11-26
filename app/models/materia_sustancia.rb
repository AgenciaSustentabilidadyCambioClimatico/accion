class MateriaSustancia < ApplicationRecord
	belongs_to :meta, foreign_key: :meta_id, class_name: :Clasificacion
  has_many :materia_rubro_relacions

	has_many :materia_sustancia_clasificaciones, foreign_key: :materia_sustancia_id, dependent: :destroy
	accepts_nested_attributes_for :materia_sustancia_clasificaciones, allow_destroy: true

	validates :meta_id, presence: true
	validates :unidad_base, presence: true, if: -> { posee_una_magnitud_fisica_asociada.present? }
	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates :posee_una_magnitud_fisica_asociada, presence: true, unless: -> { posee_una_magnitud_fisica_asociada == false }

	validate :debe_tener_al_menos_una_clasificacion

  def initialize(attributes = {})
    super(attributes)
    filtrar_nested_attributes
  end

  def update(attributes)
    super(attributes)
    filtrar_nested_attributes
  end

  def debe_tener_al_menos_una_clasificacion
  	if materia_sustancia_clasificaciones.empty?
    	errors.add("materia_sustancia_clasificaciones.clasificacion_id", 'Debe agregar al menos una clasificación')
    end
  end

  def self.descritas
    descripcion = {}
    MateriaSustancia.all.each do |ms|
      descripcion[ms.id] = {
        id: ms.id, # redudante, pero lo necesito para el filtro por clasificación
        meta_id: ms.meta_id,
        unidad_base: ms.unidad_base,
        nombre: ms.nombre,
        descripcion: ms.descripcion, #DZC el valor del campo se agrega, lee y utiliza en virtud de la gema implementada por RICARDO, en las oportunidadas que se necesita
        posee_una_magnitud_fisica_asociada: ms.posee_una_magnitud_fisica_asociada
      }
    end
    descripcion
  end

  private
    def filtrar_nested_attributes
      # Agregamos una clasificación si no viene ninguna
      if self.materia_sustancia_clasificaciones.size == 0
        self.materia_sustancia_clasificaciones.build
      else
        # Si viene, las agrupamos por ID y objeto
        msc_array = []
        self.materia_sustancia_clasificaciones.each do |msc|
          msc_array << [msc.clasificacion_id,msc]
        end
        # Reasignamos el array filtrando repetidas
        self.materia_sustancia_clasificaciones = msc_array.uniq{|msci|msci.first}.map{|m|m.last}
      end
    end

end