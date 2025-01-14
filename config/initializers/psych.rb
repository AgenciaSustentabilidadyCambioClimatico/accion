require 'psych'

class Psych::Visitors::ToRuby
  def visit_Psych_Nodes_Alias(o)
    @st[o.anchor] || super
  end
end
