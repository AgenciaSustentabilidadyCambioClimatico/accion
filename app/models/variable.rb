class Variable < ApplicationRecord
	validates :nombre, presence: true
	validates :valor, presence: true
end