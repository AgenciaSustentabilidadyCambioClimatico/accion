class PpfMetasEstablecimiento < ApplicationRecord
	has_many :set_metas_acciones
	belongs_to :establecimiento_contribuyente
	has_many :ppf_metas_comentarios, dependent: :destroy

	accepts_nested_attributes_for :set_metas_acciones
	accepts_nested_attributes_for :ppf_metas_comentarios

	#validates :estado, inclusion: { in: [ true, false ] }
	enum estado: [:pendiente, :en_revision, :observada, :aceptada]

end
