class CreateMinutaParticipantes < ActiveRecord::Migration[5.1]
  def self.up
    create_table :minuta_participantes do |t|
      t.integer :minuta_id
      t.integer :participante_id
      t.boolean :asistio
      t.timestamps
    end
    add_foreign_key :minuta_participantes, :minutas
  end
  def self.down
  drop_table :minuta_participantes
end
end
