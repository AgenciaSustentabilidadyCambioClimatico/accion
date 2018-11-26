class AddFieldsToAuditorias < ActiveRecord::Migration[5.1]
  def change
    add_column :auditorias, :ceremonia_certificacion_fecha, :date
    add_column :auditorias, :ceremonia_certificacion_direccion, :string
    add_column :auditorias, :ceremonia_certificacion_lat, :decimal
    add_column :auditorias, :ceremonia_certificacion_lng, :decimal
    add_column :auditorias, :ceremonia_certificacion_firmantes, :text
    add_column :auditorias, :ceremonia_certificacion_archivo, :json
  end
end
