class PersonaCargo < ApplicationRecord
	belongs_to :cargo
	belongs_to :persona, -> { includes [:contribuyente] }, optional: true
	# has_many :mapa_de_actores, dependent: :destroy
	validates :cargo_id, presence: true
end