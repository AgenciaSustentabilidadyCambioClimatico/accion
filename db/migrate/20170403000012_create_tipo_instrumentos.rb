class CreateTipoInstrumentos < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_instrumentos do |t|
      t.string :nombre, null: false
      t.text :descripcion, null: false
      t.integer :tipo_instrumento_id
    end
    add_index :tipo_instrumentos, :nombre,	unique: true
    add_foreign_key :tipo_instrumentos, :tipo_instrumentos
  end
  
  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "tipo_instrumentos" ("id", "nombre", "descripcion", "tipo_instrumento_id") VALUES
        (1, 'Programas y Proyectos de Financiamiento',  'Programas y proyectos a los cuales la agencia postula o apoya la postulación de terceros', NULL),
        (2, 'Programas o Proyectos Propuestos y Ejecutados por Terceros', 'Este tipo de proyectos solo requiere una carta de apoyo y un seguimiento básico al proyecto aprobado.',  1),
        (3, 'Programas o Proyectos Propuestos por la Agencia y Ejecutados por Terceros',  'Este tipo de proyectos son presentado y defendidos por la ASCC, pero es un tercero quien se encarga de su gestión administrativa.',  1),
        (4, 'Acuerdo de Producción Limpia', 'Acuerdo de Producción Limpia es el convenio celebrado entre un sector empresarial, empresa o empresas y él o los órganos de la Administración del Estado con competencia en materias ambientales, sanitarias, de higiene y seguridad laboral, uso de la energía y de fomento productivo, cuyo objetivo es aplicar la producción limpia a través de metas y acciones específicas.

        Los Acuerdos de Producción Limpia tienen por finalidad contribuir al desarrollo sustentable de las empresas a través de la definición de metas y acciones específicas, no exigidas por el ordenamiento jurídico en materias ambientales, sanitarias, de higiene y seguridad laboral, uso eficiente de la energía y de fomento productivo.', NULL),
        (5, 'APL de Establecimientos Productivos',  'Acuerdo que tiene por objetivo certificar el cumplimiento de compromisos adoptados a nivel de establecimiento productivo, están basados en NCH 2807.', 4),
        (6, 'APL de Preinversión',  'Acuerdo que tiene por objetivo promover y certificar la adopción de altos estándares socioambientales por parte de proyectos de inversión, mediante la implementación temprana de procesos participativos que faciliten el logro de acuerdos orientados a mejorar el proyecto y sus beneficios, así como a crear relaciones constructivas de largo plazo entre empresas, comunidades locales y otros actores de interés.', 4),
        (7, 'APL de Gestión de Cuencas y Recursos Hídricos',  'El APL para la Gestión de Cuencas se expresa en un Convenio entre empresas, organismos públicos competentes y otras organizaciones involucradas, para fomentar la producción limpia y el desarrollo sustentable mediante una gestión coordinada de una cuenca y su entorno', 4),
        (8, 'APL de Certificación en Sustentabilidad',  'Este tipo de Acuerdo se distingue por un diagnóstico basado en la generación de estándares mediante levantamiento de requisitos con partes interesadas, al cual las organizaciones pueden adherir y certificar en cualquier momento durante la vigencia del mismo.', 4),
        (10,  'Fondo de Producción Limpia', 'El Fondo de Promoción de Producción Limpia (Fondo PL), es una iniciativa del Consejo Nacional de Producción Limpia (CPL), que tiene por finalidad apoyar a las empresas, a través de sus organizaciones, en la implementación de Producción Limpia.',  NULL),
        (11,  'Línea 1.1 - Diagnóstico de APL NCH', 'Fondo de Apoyo a la Elaboración de Diagnósticos de Acuerdos de Producción Limpia Regidos por la NCH 2797', 10),
        (12,  'Línea 1.2 - Implementación de APL',  'Fondo de Apoyo a la Implementación de Acuerdos de Producción Limpia por la NCH 2797.', 10),
        (13,  'Línea 1.3 - Certificación de APL', 'Fondo de Apoyo a la Certificación de Acuerdos de Producción Limpia', 10),
        (14,  'Línea 2.1 - Formación de Capacidades en Producción Limpia',  'Fondo de Apoyo a la Capacitación en Producción Limpia',  10),
        (15,  'Línea 2.2 - Formación de Capacidades en Acuerdos de Producción Limpia',  'Fondo de Apoyo a la Capacitación en Acuerdos de Producción Limpia',  10),
        (16,  'Línea 3 - Misiones de Cooperación en Producción Limpia', 'Fondo de Apoyo a la realización de misiones para la transferencia y difusión de prácticas de producción limpia.',  10),
        (17,  'Línea 4 - Difusión Beneficios APL y Producción Limpia',  'Fondo de Apoyo a la Difusión de los beneficios de los Acuerdos de Producción Limpia y de la Producción Limpia en General.',  10),
        (18,  'Programas o Proyectos Propuestos y Ejecutados por la Agencia', 'Este tipo de proyectos son presentados y ejecutados por la ASCC.', 1),
        (20,  'APL de Adaptación y Gestión de Riesgos', 'Estos Acuerdos buscan fomentar la gestión coordinada del territorio asociada a sus factores de riesgo, en particular riesgos de incendios, con el fin de contribuir a su sustentabilidad y enfrentar los desafíos del cambio climático. ', 4),
        (21,  'Línea 5.1.2 - Propuestas de Acuerdo en Gestión de Cuencas y Recursos Hídricos',  'Fondo de Apoyo a la Ejecución de las Etapas de Diagnóstico General y Propuesta del Acuerdo en Gestión de Cuencas y Recursos Hídricos.',  10),
        (22,  'Línea 5.1.1 - Propuestas de Acuerdo sobre Proyectos de Inversión', 'Fondo de Apoyo a la Ejecución de las Etapas de Diagnóstico General y Propuesta del Acuerdo en Acuerdos de Producción Limpia de Preinversión',  10),
        (23,  'Línea 5.1.3 - Propuestas de Acuerdo en Adaptación y Gestión de Riesgos', 'Fondo de Apoyo a la Ejecución de las Etapas de Diagnóstico General y Propuesta del Acuerdo en Acuerdos de Producción Limpia de Adaptación y Gestión de Riesgos', 10),
        (24,  'Línea 5.2 - Implementación de APL Territoriales',  'Fondo de Apoyo a la Implementación de Acuerdos de Producción Limpia Territoriales.', 10);
      SELECT SETVAL('tipo_instrumentos_id_seq', (SELECT MAX(id) FROM tipo_instrumentos));
    SQL
  end
end