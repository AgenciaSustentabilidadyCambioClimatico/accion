class CreateEtapas < ActiveRecord::Migration[5.1]
  def change
    create_table :etapas do |t|
      t.integer :etapa_id
      t.integer :orden
      t.string :nombre, null: false
      t.text :descripcion
    end
    add_foreign_key :etapas, :etapas
  end

  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO etapas (etapa_id,orden,nombre,descripcion) VALUES
        (NULL,NULL,'Diagnóstico General','Etapa en la cual se genera un diagnóstico general de la situación que permite platear los objetivos y la propuesta inicial de metas y acciones del Acuerdo que permiten lograr esos objetivos así como abordar las brechas detectadas.'),
        (1,1,'Admisibilidad','Análisis de Forma respecto de los antecedentes presentados, es decir, se asegura que fueron correctamente presentados.'),
        (1,2,'Pertinencia y Factibilidad','Análisis de Fondo respecto de los antecedentes proyectados, para asegurar que el acuerdo propuesto es adecuado y que posee el apoyo necesario para tener un desenlace exitoso.'),
        (1,4,'Mapa Actores','Etapa en la que se definen los actores relevantes para efectos del diagnóstico, negociación, encuesta y consulta del acuerdo.'),
        (NULL,NULL,'Acuerdo en General','Esto significa que la tarea está activa a lo largo de varias etapas del acuerdo.'),
        (5,3,'Prensa Acuerdo','En esta etapa se carga prensa asociada al acuerdo');
    SQL
  end

end