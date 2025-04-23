class ListadoActoresTemporal < ApplicationRecord
  belongs_to :manifestacion_de_interes

  def self.actualiza_estado_listado_mapa_actores(manifestacion_de_interes_id)
    listado_actores_temporal = where(manifestacion_de_interes_id: manifestacion_de_interes_id, estado: 0)
    listado_actores_temporal.update_all(estado: 1)
  end

  def self.habilita_listado_mapa_actores(manifestacion_de_interes_id)
    listado_actores_temporal = where(manifestacion_de_interes_id: manifestacion_de_interes_id, estado: 1)
    listado_actores_temporal.update_all(estado: 0)
  end
end
