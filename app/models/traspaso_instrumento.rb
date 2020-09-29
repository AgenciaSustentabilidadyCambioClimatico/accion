class TraspasoInstrumento < ApplicationRecord

  belongs_to :origen, class_name: "User"
  belongs_to :flujo
  belongs_to :destino, class_name: "User"

  attr_accessor :usuario_origen, :usuario_destino, :no_fecha_retorno

  enum tipo_traspaso: [ :fuera_de_oficina, :heredado ]

  validates :usuario_origen, presence: true
  validates :flujo_id, presence: true
  validates :usuario_destino, presence: true
  validates :tipo_traspaso, presence: true
  validates :fecha_retorno, presence: true, if: -> { tipo_traspaso == "fuera_de_oficina"}

  after_create :traspaso_efectivo

  def traspaso_efectivo
  	#Realiza el traspaso
  	personas_origen = self.origen.personas.pluck(:id)
    #obtengo la persona asociada a la misma empresa que el de origen
  	persona_destino = self.destino.personas.last
  	#Primero el mapa de actores, por si hay justo alguien realizando un flujo
  	MapaDeActor.where(flujo_id: self.flujo_id, persona_id: personas_origen).update_all(persona_id: persona_destino.id)
  	#Despues las tareas pendientes
  	TareaPendiente.where(flujo_id: self.flujo_id, user_id: self.origen.id).update_all(user_id: self.destino.id)
    #envio correo
    TraspasoMailer.notificar(self).deliver_now
  	#fin
  end

  def retornar_traspaso
  	#lo mismo de arriba pero al revez
  	persona_origen = self.origen.personas.last
  	personas_destino = self.destino.personas.pluck(:id)
  	MapaDeActor.where(flujo_id: self.flujo_id, persona_id: personas_destino).update_all(persona_id: persona_origen.id)
  	TareaPendiente.where(flujo_id: self.flujo_id, user_id: destino.id).update_all(user_id: origen.id)
    #TraspasoMailer.notificar(self).deliver_now
  end


end
