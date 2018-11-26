##
# Validates if the given string has the correct rut/run syntax
# and if the rut/run has the correct digit.

class RutValidator < ActiveModel::EachValidator
  ##
  # @param value [String] the string to be validated
  def validate_each(record, attribute, value)
    if value.nil? or not value.is_a?(String)
      record.errors[attribute] << (options[:message] || "El RUT ingresado es inválido")
    elsif not value.rut_valid?
      record.errors[attribute] << (options[:message] || "El RUT ingresado es inválido")
    end
  end
end
