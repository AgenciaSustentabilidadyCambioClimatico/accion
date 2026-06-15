class ListadoAdhesionesTemporal < ApplicationRecord
    belongs_to :flujo

    mount_uploader :nombre_archivo, ArchivoNombreArchivoListadoAdhesionesUploader

    def self.actualiza_estado_listado_adhesiones(flujo_id)
        listado_adhesiones_temporal = where(flujo_id: flujo_id, estado: 0)
        listado_adhesiones_temporal.update_all(estado: 1)
    end
end
