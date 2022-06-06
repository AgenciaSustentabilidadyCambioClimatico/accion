class ReporteSustentabilidad < ApplicationRecord

  validates :titulo_intro, length: {minimum: 1, maximum: 255}, allow_blank: false
  validates :cuerpo_intro, presence: true
end
