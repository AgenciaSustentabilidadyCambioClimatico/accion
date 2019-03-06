class CreateInformeAcuerdos < ActiveRecord::Migration[5.1]
  def change
    create_table :informe_acuerdos do |t|
      t.references :manifestacion_de_interes, index: true, foreign_key: true
      t.text :fundamentos
      t.text :antecedentes
      t.text :normativas_aplicables
      t.text :alcance
      t.text :campo_de_aplicacion
      t.text :definiciones
      t.text :objetivo_general
      t.text :objetivo_especifico
      t.text :mecanismo_de_implementacion
      t.integer :tipo_acuerdo
      t.integer :plazo_maximo_adhesion
      t.integer :plazo_finalizacion_implementacion
      t.text :mecanismo_evaluacion_cumplimiento
      t.date :plazo_maximo_neto
      t.date :plazo_maximo
      t.boolean :adhesiones
      t.boolean :con_validacion
      t.text :derechos
      t.text :obligaciones
      t.text :difusion
      t.text :promocion
      t.text :incentivos
      t.text :sanciones
      t.text :personerias
      t.text :ejemplares
      t.text :firmas
      t.json :archivos_anexos, default: []
      t.timestamps
    end
  end
end
