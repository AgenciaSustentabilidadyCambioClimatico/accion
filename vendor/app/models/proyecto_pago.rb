class ProyectoPago < ApplicationRecord
	belongs_to :proyecto

	validates :monto, presence: true
	validates :numero_orden_pago, presence: true, if: proc{ self.modelo == "orden" }
	validates :fecha_pago_efectiva, presence: true, if: proc{ self.modelo == "fecha" }
	validate :fecha_menor_inicio_proyecto, if: proc{ self.modelo == "fecha" }
	# validate :monto_menor_validacion

	attr_accessor :modelo

	def monto_menor_validacion
		maximo_posible = 0 #= self.proyecto.maximo_posible
		if maximo_posible > self.monto
			errors.add(:monto, I18n.t('monto_no_puede_ser_mayor_al_máximo'))
		end
	end

	def pagado
		!self.numero_orden_pago.blank? && !self.fecha_pago_efectiva.blank?
	end

	def fecha_menor_inicio_proyecto
		if self.proyecto.fecha_iniciacion >= self.fecha_pago_efectiva
			errors.add(:fecha_pago_efectiva, "Fecha de pago debe ser mayor a fecha de inicio de proyecto")
		end 
	end
end