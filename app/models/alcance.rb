class Alcance < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true
  validate :valida_editable

  ORGANIZACION = 1
  ESTABLECIMIENTO = 2
  MAQUINARIA = 3
  PRODUCTO = 4

  attr_accessor :nombre_anterior

  # DZC 2018-10-26 11:29:45 validación para edición de alcances no editables
  def valida_editable
    # 
    if !self.es_editable? && (self.nombre != self.nombre_anterior)
      self.errors.add(:nombre, "No se puede modificar el nombre de los alcances Organización, Establecimiento y Maquinaria")
      false
    else
      true
    end
  end

  # DZC 2018-10-26 11:29:11 listado de alcances no editables
  def no_editables
    [
      "Organización",
      "Establecimiento",
      "Maquinaria"
    ]
  end

  # DZC 2018-10-26 11:29:23 devuelve true si el alcance es editable
  def es_editable?
    !self.no_editables.include?(nombre_anterior)
  end



  def self.obtener_alcances_para_otros
    excepto_estos = [Alcance::ORGANIZACION, Alcance::ESTABLECIMIENTO, Alcance::MAQUINARIA] # Organización, Establecimiento y Maquinaria
    Alcance.where.not(id: excepto_estos).all.map { | alcance | [alcance.nombre, alcance.id] }
  end  
end
