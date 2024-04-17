class Linea < ApplicationRecord
    def self.carga_sub_lineas(linea_id)
        #binding.pry
        @sub_lineas = SubLinea.where(linea_id: linea_id)
        #@sub_lineas = SubLinea.where(linea_id: )
    end
end
