class Encuesta < ApplicationRecord
  has_many :encuesta_preguntas, -> { includes :pregunta }, foreign_key: :encuesta_id, dependent: :destroy
  accepts_nested_attributes_for :encuesta_preguntas, allow_destroy: true #, update_only: true

  enum unidad_tiempo_para_contestar: [:hours,:days,:weeks]

  validates :titulo, presence: true
  validates :valor_tiempo_para_contestar, presence: true, numericality: { greater_than: 0 }
  validates :unidad_tiempo_para_contestar, presence: true
  validates :solo_dias_habiles, presence: true, unless: -> { solo_dias_habiles == false }

  def initialize(attributes = {})
    super(attributes)
    filtrar_nested_attributes
  end

  def update(attributes)
    super(attributes)
    filtrar_nested_attributes
  end

  def filtrar_nested_attributes
    # Agregamos una encuesta_pregunta si no viene ninguna
    if self.encuesta_preguntas.size == 0
      self.encuesta_preguntas.build
    else
      # Si viene, las agrupamos por ID y objeto
      ep_array = []
      self.encuesta_preguntas.each do |ep|
        ep_array << [ep.pregunta_id,ep]
      end
      # Reasignamos el array filtrando repetidos
      self.encuesta_preguntas = ep_array.uniq{|epi|epi.first}.map{|m|m.last}
    end
  end

  def expirada?(fecha_creacion)
    # DZC 2018-11-08 11:51:44 se modifica para que compare dia y hora, y setea la fecha y hora actual a UTC en concordancia con el manejo de timestamp del SGBD (Postgresql)
    DateTime.now.utc > dia_de_expiracion(fecha_creacion)
  end

  def dia_de_expiracion(fecha_creacion)
    vt = self.valor_tiempo_para_contestar
    ut = self.unidad_tiempo_para_contestar
    fecha_expiracion = fecha_creacion+vt.send(ut)
    #DZC Se decide eliminar la programación de feriados por ahora
    # if solo_dias_habiles
    #   fecha_expiracion = Feriado.encontrar_el_dia_habil(vt,ut,fecha_creacion)
    # end
    fecha_expiracion
  end
end