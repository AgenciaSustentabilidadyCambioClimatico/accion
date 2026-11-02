class ReporteriaDato < ApplicationRecord

  serialize :datos, coder: YAML

end
