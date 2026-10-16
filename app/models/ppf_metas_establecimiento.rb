class PpfMetasEstablecimiento < ApplicationRecord
	has_many :set_metas_acciones
	belongs_to :establecimiento_contribuyente
	has_many :ppf_metas_comentarios, dependent: :destroy

	accepts_nested_attributes_for :set_metas_acciones
	accepts_nested_attributes_for :ppf_metas_comentarios

	#validates :estado, inclusion: { in: [ true, false ] }
	# Declaración explícita de atributo para Rails 7.2
	attribute :estado, :integer # (o :string si se almacena como texto en DB)

	# Definición del enum con sintaxis de Rails 7+ y prefijo
	enum :estado, [:pendiente, :en_revision, :observada, :aceptada], prefix: :estado

end
