class Correlativo < ApplicationRecord
    def self.obtener_correlativo
        year = Date.today.year
        correlativo = find_or_initialize_by(year: year)
        correlativo.valor ||= 0
        correlativo.valor += 1
        correlativo.save
        correlativo.formatear_valor
      end
    
      def formatear_valor
        "%01d" % valor
      end
end
