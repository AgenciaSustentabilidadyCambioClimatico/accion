class PureDocx::XmlGenerators::Text
	DEFAULT_FONT_FAMILY = 'Verdana'
	DEFAULT_TEXT_COLOR 	= '000000'
  attr_reader :font_family, :color
  alias_method :original_initialize, :initialize

  def initialize(content, rels_constructor, arguments = {})
    original_initialize(content, rels_constructor, arguments)
    @font_family	= arguments[:font_family] || DEFAULT_FONT_FAMILY
    @color	= arguments[:color]  || DEFAULT_TEXT_COLOR
  end
 	def params
    {
      '{TEXT}'          => content,
      '{ALIGN}'         => align,
      '{BOLD_ENABLE}'   => bold_enable,
      '{ITALIC_ENABLE}' => italic_enable,
      '{SIZE}'          => size,
      '{FONT_FAMILY}'		=> font_family,
      '{FONT_ASCII}' 		=> font_family.split(" ")[0],
      '{FONT_ANSI}' 		=> font_family.split(" ")[0],
      '{TEXT_COLOR}'		=> color
    }
  end
	def template
		File.read(Rails.root.join('lib','templates','paragraph.xml'))
  end
end

module PureDocx::ClassMethods
  def create(file_path, options = {})
    doc = PureDocx::Document.new(file_path, options)
    yield doc if block_given?
    doc
  end
end