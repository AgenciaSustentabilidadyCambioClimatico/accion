class PpfMetasComentario < ApplicationRecord
	belongs_to :ppf_metas_establecimiento
	belongs_to :user

end
