class CreateRegistroAperturaCorreos < ActiveRecord::Migration[5.1]
  def change
    create_table :registro_apertura_correos do |t|      
      t.belongs_to :user, foreign_key: true
      t.belongs_to :flujo, foreign_key: true
      t.belongs_to :flujo_tarea, foreign_key: true
      t.belongs_to :convocatoria_destinatario, foreign_key: true
      t.datetime :fecha_envio_correo
      t.datetime :fecha_apertura_correo
      t.boolean :estado, default: false
      t.boolean :asistio, default: false

      t.timestamps
    end
  end
end
