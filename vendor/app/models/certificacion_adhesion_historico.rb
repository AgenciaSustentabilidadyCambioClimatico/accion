class CertificacionAdhesionHistorico < ApplicationRecord
	belongs_to :adhesion_elemento, optional: true
end
