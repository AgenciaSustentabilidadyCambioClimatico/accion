class ListadoAdhesionesTemporal < ApplicationRecord
    belongs_to :flujo

    attr_accessor :user_id, :rol_en_acuerdo_id, :cargo_institucion_id, :direccion
    attr_accessor :rol_en_acuerdo, :nombre, :rut, :cargo_institucion, :email_institucional, :telefono_institucional
    
    attr_accessor :contribuyente_id, :tipo_institucion_id, :codigo_ciiuv4
    attr_accessor :razon_social_institucion, :rut_institucion, :tipo_institucion, :comuna_institucion, :tamano_contribuyente, :alcance
end
