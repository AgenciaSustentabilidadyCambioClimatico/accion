class Campo < ApplicationRecord
	has_many :campo_tareas, dependent: :delete_all
	has_many :tareas, through: :campo_tareas

  # DOSSA 18-07-2019 se agregan validaciones correspondientes para los campos.
  attr_accessor :sin_validaciones #DZC 2019-07-25 16:48:22 se agrega para poblar la tabla desde el seed sin validaciones

  # DZC 2019-07-25 17:00:03 se agrega para ejecutar la asignación de valores a tributos booleanos en el caso de que el navegador no envíe el parámetro por ser false
  before_validation :set_valores_de_verdad

  # DZC 2019-07-25 16:50:47 se modifica para poblar la tabla desde el seed sin validaciones
  with_options unless: :sin_validaciones do |validando|
    validando.validates :nombre, presence: true
    validando.with_options if: :validaciones_activas do |validacion_activa|
      validacion_activa.validates :validacion_min, numericality: {
       greater_than_or_equal_to: 1,
        less_than_or_equal_to: 9223372036854775807
      }, presence: true, if: :validacion_min_activa
      validacion_activa.validates :validacion_max, numericality: { 
        greater_than_or_equal_to: 1,
        less_than_or_equal_to: 9223372036854775807
      }, presence: true, if: :validacion_max_activa
      validacion_activa.validate :max_lower?
      # validacion_activa.validate :largo_min_max
    end
    validando.validates :validacion_vacio_mensaje, presence: true, if: :validacion_contenido_obligatorio
    validando.validates :ayuda, presence: true, if: :ayuda_activo
    validando.validates :tooltip, presence: true, if: :tooltip_activo
  end

  # DZC 2019-07-25 16:53:31 ajusta los valores booleanos para el caso de que el navegador no envíe el parámetro por ser false
  def set_valores_de_verdad
    self.validaciones_activas = self.validaciones_activas?
    self.validacion_min_activa = self.validacion_min_activa?
    self.validacion_max_activa = self.validacion_max_activa?
    self.validacion_contenido_obligatorio = self.validacion_contenido_obligatorio?
    self.tooltip_activo = self.tooltip_activo?
    self.ayuda_activo = self.ayuda_activo?
  end

  # DZC 2019-07-25 16:51:21 se agrega para manejar validaciones individuales de booleanos 
  def validaciones_activas?
   self.validaciones_activas.present? ? true : false
  end

  # DZC 2019-07-25 16:51:21 se agrega para manejar validaciones individuales de booleanos 
  def validacion_min_activa?
    self.validacion_min_activa.present? ? true : false
  end

  # DZC 2019-07-25 16:51:21 se agrega para manejar validaciones individuales de booleanos
  def validacion_max_activa?
    self.validacion_max_activa.present? ? true : false
  end

  # DZC 2019-07-25 16:51:21 se agrega para manejar validaciones individuales de booleanos
  def validacion_contenido_obligatorio?
    self.validacion_contenido_obligatorio.present? ? true : false
  end  

  # DZC 2019-07-25 16:51:21 se agrega para manejar validaciones individuales de booleanos
  def tooltip_activo?
    self.tooltip_activo.present? ? true : false
  end 

  # DZC 2019-07-25 16:51:21 se agrega para manejar validaciones individuales de booleanos
  def ayuda_activo?
    self.ayuda_activo.present? ? true : false
  end 

  # DZC 2019-07-25 16:51:21 se agrega para manejar validaciones individuales de booleanos
  def sin_validaciones?
    self.sin_validaciones.present? ? true : false
  end

  def max_lower?
    if validacion_max_activa && validacion_min_activa
      if validacion_max.present? && validacion_min.present?
        if validacion_max < validacion_min
          errors.add(:validacion_max, "El valor máximo no puede ser menor que el valor mínimo.")
        end
      end
    end
  end

  def _as_select
    Campo.where(clase: self.clase).map{|c| ["#{c.id_referencial} | #{c.nombre}", c.id]}
  end

  # def largo_min_max
  #   if validacion_min > 9223372036854775807
  #     errors.add(:validacion_min, "El valor mínimo no puede ser tan extenso.")
  #   end
  #   if validacion_max > 9223372036854775807
  #     errors.add(:validacion_max, "El valor máximo no puede ser tan extenso.")
  #   end
  # end
end
