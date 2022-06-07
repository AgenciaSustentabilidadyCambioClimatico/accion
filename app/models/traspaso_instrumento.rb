class TraspasoInstrumento < ApplicationRecord

  belongs_to :origen, class_name: "User"
  belongs_to :flujo
  belongs_to :destino, class_name: "User"

  attr_accessor :usuario_origen, :usuario_destino, :no_fecha_retorno

  enum tipo_traspaso: [ :fuera_de_oficina, :heredado ]

  serialize :cambios_mapa_de_actores
  serialize :cambios_tareas_pendientes

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
    cambios_mapa_de_actores = []
  	MapaDeActor.where(flujo_id: self.flujo_id, persona_id: personas_origen).each do |ma|
      cambios_mapa_de_actores << {
        persona_origen: ma.persona_id,
        persona_destino: persona_destino.id,
        rol: ma.rol_id
      }
      ma.update(persona_id: persona_destino.id)
    end
  	#Despues las tareas pendientes
    cambios_tareas_pendientes = []
  	TareaPendiente.where(flujo_id: self.flujo_id, user_id: self.origen.id).each do |tp|
      cambios_tareas_pendientes << {
        persona_origen: tp.persona_id,
        usuario_origen: tp.user_id,
        persona_destino: persona_destino.id,
        usuario_destino: self.destino.id,
        tarea_id: tp.tarea_id
      }
      actualizacion = {user_id: self.destino.id}
      actualizacion[:persona_id] = persona_destino.id if !tp.persona.blank?
      tp.update(actualizacion)
    end
    self.cambios_mapa_de_actores = cambios_mapa_de_actores
    self.cambios_tareas_pendientes = cambios_tareas_pendientes
    self.save
    #envio correo
    TraspasoMailer.notificar(self).deliver_now
  	#fin
  end

  def retornar_traspaso
  	#lo mismo de arriba pero al revez
  	persona_origen = self.origen.personas.last
  	personas_destino = self.destino.personas.pluck(:id)
    if self.cambios_mapa_de_actores.blank?
      MapaDeActor.where(flujo_id: self.flujo_id, persona_id: personas_destino).update_all(persona_id: persona_origen.id)
    else
      self.cambios_mapa_de_actores.each do |cambio|
        MapaDeActor.where(flujo_id: self.flujo_id, rol_id: cambio[:rol], persona_id: cambio[:persona_destino]).update(persona_id: cambio[:persona_origen])
      end
    end
    if self.cambios_tareas_pendientes.blank?
      TareaPendiente.where(flujo_id: self.flujo_id, user_id: destino.id).update_all(user_id: origen.id)
    else
      self.cambios_tareas_pendientes.each do |cambio|
        tp = TareaPendiente.where(flujo_id: self.flujo_id, tarea_id: cambio[:tarea_id], user_id: cambio[:usuario_destino])
        actualizacion = {user_id: cambio[:usuario_origen]}
        if !cambio[:persona_origen].blank?
          tp = tp.where(persona_id: cambio[:persona_destino])
          actualizacion[:persona_id] = cambio[:persona_origen]
        end
        tp.update(actualizacion)
      end
    end
    #TraspasoMailer.notificar(self).deliver_now
  end


end
