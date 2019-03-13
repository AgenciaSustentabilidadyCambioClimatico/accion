class String
  def upcase
  	self.mb_chars.upcase.to_s
  end
  def capitalize(o=nil)
  	if o == :all
  		self.downcase.split.map(&:capitalize).join(' ')
  	else
  		self.dup.capitalize!
  	end
  end

  def as_key
    self.downcase.gsub(/[\s\-]/,'_').to_sym
  end

  def to_compare
    I18n.transliterate(self).upcase
  end

  def new_hash(e)
    nh={}
    e.each do |k,v|
      if v.is_a?(Hash)
        nh[k.to_sym] = new_hash(v)
      else
        nh[k.to_sym]=v
      end
    end
    nh
  end
  
  def as_hash()
    nh = {}
    begin
      JSON.parse(self).dup.each do |k,v|
        if v.is_a?(Hash)
          nh[k.to_sym] = new_hash(v)
        else
          nh[k.to_sym] = v
        end
      end
    rescue Exception => e
      puts e
    end
    nh
  end

  def email_valid?
    ! (self =~ /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i).blank?
  end

  def phone_valid?
    self == self.to_i.to_s
  end

  def number_valid?
    self == self.to_i.to_s
  end

  #permite saber si es un numero entero valido y mayor que 0
  def numeric?
    Integer(self) != nil && Integer(self) >= 0 rescue false
  end

  def double_valid?
    begin
      "%.2f" % self
    rescue
      false
    end
  end

  def date_valid?
    valid = true
    begin
      Date.parse(self)
    rescue => e
      valid = false
    end
    valid
  end
end