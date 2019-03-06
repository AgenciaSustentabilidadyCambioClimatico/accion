class CreateConvocatoriaDestinatarios < ActiveRecord::Migration[5.1]
  def self.up
    create_table :convocatoria_destinatarios do |t|
      t.integer :convocatoria_id
      t.integer :destinatario_id
      t.timestamp :fecha_correo
      t.boolean :asistio, default: false
      t.timestamps
    end
    add_foreign_key :convocatoria_destinatarios, :convocatorias
  end
  def self.down
  		drop_table :convocatoria_destinatarios
  end
end