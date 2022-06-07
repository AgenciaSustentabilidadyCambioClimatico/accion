class CreateReporteSustentabilidads < ActiveRecord::Migration[5.1]
  def change
    create_table :reporte_sustentabilidads do |t|
      t.string :titulo_intro
      t.text :cuerpo_intro
      t.timestamps
    end
  end
end
