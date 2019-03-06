class ApplicationModel
  include ActiveModel::Model 
  include ActiveModel::Validations::Callbacks

  def initialize(__data={})
  	unless ( __data.blank? ||__data.is_a?(Hash) == false )
  		load_data_to_attributes(__data)
  	end
  end

  def __attr_fields
    self.class.instance_methods(false).map(&:to_s).keep_if{|a|a.include?('=')}.map{|a|a.sub('=','').to_sym}
  end

  def load_data_to_attributes(data)
    if data.is_a?(Hash)
      data.each do |attr,value|
        if self.respond_to?(attr)
          self.send("#{attr}=",value)
        end
      end
    end
  end

  def load_attributes_to_data
    if self.respond_to?(:data)
      self.data = {} if self.data.blank?
      __attr_fields.sort.each do |attr|
        if self.respond_to?(attr) && :data != attr
          unless self.send(attr).blank? || self.send(attr) == self.data[attr]
            self.data[attr] = self.send(attr)
          end
        end
      end
    end
    self
  end
end