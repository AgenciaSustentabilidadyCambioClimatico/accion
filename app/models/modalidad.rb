class Modalidad < ApplicationRecord

	has_many :rendiciones

	ANTICIPO = 1
	REEMBOLSO = 2

	def self.as_select
		[["Anticipo",ANTICIPO],["Reembolso",REEMBOLSO]]
	end
end