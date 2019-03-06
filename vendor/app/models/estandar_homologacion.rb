class EstandarHomologacion < ApplicationRecord
	mount_uploaders :referencias, EstandaHomologacionReferenciaUploader
	has_many :estandar_set_metas_acciones, dependent: :destroy
	accepts_nested_attributes_for :estandar_set_metas_acciones, allow_destroy: true, reject_if: :all_blank

	validates :nombre, presence: true
end
