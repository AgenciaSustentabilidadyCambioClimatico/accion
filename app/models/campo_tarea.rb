class CampoTarea < ApplicationRecord
	belongs_to :campo
  belongs_to :tarea

  validates_presence_of :tarea
  validates_presence_of :campo

  accepts_nested_attributes_for :campo
end
