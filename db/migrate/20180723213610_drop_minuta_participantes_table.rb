class DropMinutaParticipantesTable < ActiveRecord::Migration[5.1]
  def change
  	drop_table :minuta_participantes
  end
end
