class RangoVentaContribuyente < ApplicationRecord
	belongs_to :tamano_contribuyente
	has_many :dato_anual_contribuyentes

	def self.__select
		RangoVentaContribuyente.includes([:tamano_contribuyente]).all.map{|rvc| 
			["#{rvc.rango} - #{rvc.tamano_contribuyente.nombre} - #{rvc.venta_anual_en_uf}",rvc.id]
		}
	end

  def self.get_by_venta(uf)
    self.all.each do |rvc|
      return rvc if rvc.esta_en_rango(uf)
    end
    nil
  end

  def esta_en_rango(uf)
    rangos = self.venta_anual_en_uf.scan(/(\d+[.,]\d+)/).flatten.map{|v| v.to_f}
    if rangos.size == 0
      uf == 0.00
    elsif rangos.size == 1
      uf >= rangos[0]
    else
      uf >= rangos[0] && uf < rangos[1]
    end
  end

  def nombre_completo
    "#{rango} - #{tamano_contribuyente.nombre} - #{venta_anual_en_uf}"
  end
end