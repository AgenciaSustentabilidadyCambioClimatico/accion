class CreateActividades < ActiveRecord::Migration[5.1]
  def change
    create_table :actividades do |t|
      t.string :nombre, null: false
      t.text :descripcion, null: false
    end
  end
  
  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "actividades" ("id", "nombre", "descripcion") VALUES
        (1, 'Elaborar Diagnóstico de Acuerdo de Producción Limpia y Propuesta de APL NCH',  'El Diagnóstico Base y Propuesta del APL NCH debe contener una caracterización general del sector, subsector o grupo de empresas, utilizando las metodologías y formatos señalados en guía elaborada por la ASCC: Guía N°1: “GUÍA PARA LA ELABORACIÓN DE UN DIAGNÓSTICO COMO BASE PARA PROPONER UN ACUERDO DE PRODUCCIÓN LIMPIA”. '),
        (2, 'Elaboración del Plan de Trabajo del proyecto.',  'Elaboración del Plan de Trabajo del proyecto.'),
        (3, 'Elaboración del Informe Consolidado del Diagnóstico Inicial',  'Elaboración del Informe Consolidado del Diagnóstico Inicial.'),
        (4, 'Elaboración de los informes Consolidados de las auditorías intermedias', 'Elaboración de los informes Consolidados de las auditorías intermedias.'),
        (5, 'Talleres de Difusión con los Beneficiarios', 'Talleres de Difusión con los Beneficiarios.'),
        (6, 'Talleres o seminarios para las empresas del APL, siempre que tengan como fin apoyar el cumplimiento del acuerdo.', 'Talleres o seminarios para las empresas con instalaciones adheridas en el acuerdo, siempre y cuando tengan como fin apoyar el cumplimiento de las metas y acciones comprometidas.'),
        (7, 'Capacitaciones a empresas del APL, siempre y cuando tengan como fin apoyar su cumplimiento', 'Capacitaciones a las empresas con instalaciones adheridas en el acuerdo, siempre y cuando tengan como fin apoyar el cumplimiento de las metas y acciones por parte de las mismas.'),
        (8, 'Reuniones de Coordinación',  'Reuniones de Coordinación.'),
        (9, 'Elaboración de MTD, manuales o guías', 'Elaboración de MTD, manuales o guías.'),
        (10,  'Realización de los diagnósticos iniciales por instalación',  'Realización de los diagnósticos iniciales por instalación.'),
        (11,  'Elaboración del Plan de Implementación por Instalación', 'Elaboración del Plan de Implementación por Instalación.'),
        (12,  'Realización de Auditorías Intermedias por Instalación',  'Realización de Auditorías Intermedias por Instalación.'),
        (13,  'Elaboración de documentación y registros, visitas técnicas, y otras acciones por Instalación para cumplir el acuerdo.',  'Apoyo en la elaboración de documentación, realización de visitas técnicas, elaboración de registros, u otras acciones actividades específicas para el cumplimiento de APL, por Instalación.'),
        (14,  'Diseño del Plan de Auditoría', 'Diseño del Plan de Auditoría.'),
        (15,  'Elaboración del Informe Consolidado Final',  'Elaboración del Informe Consolidado Final.'),
        (16,  'Coordinación y realización del Informe de Evaluación de Impacto',  'Coordinación y realización del Informe de Evaluación de Impacto.'),
        (17,  'Taller de Difusión: Criterios de Auditoría', 'Taller de Difusión: Criterios de Auditoría'),
        (18,  'Validación de Resultados', 'Validación de Resultados.'),
        (19,  'Difusión de Resultados', 'Difusión de Resultados.'),
        (20,  'Auditoría Final por Instalación',  'Auditoría Final por Instalación.'),
        (21,  'Formación en tecnológias de PL', 'Acciones para formación en conocimiento tecnológicos especializados en producción limpia: Prevención y Contaminación en el Origen. Mejoramiento de la eficiencia productiva, buenas prácticas de manufactura y tecnologías de procesos productivos. Mejores técnicas disponibles. Diseño de procesos o productos con menor impacto ambiental. Recuperación y reutilización de residuos o subproductos. Valorización y reciclaje de residuos. Higiene y Seguridad Industrial Huella hídrica, Huella de Carbono, Responsabilidad Extendida del Productor, Ecodiseño, Turismo Sustentable, Ciclo de vida del Producto Otros relacionados con la Producción y Tecnología Limpias.'),
        (22,  'Formación en APL', 'Formación y desarrollo de competencias y capacidades en Acuerdos de Producción Limpia'),
        (23,  'Instancias de Trabajo previas a Misión', 'Instancias de Trabajo previas a Misión'),
        (24,  'Ejecución de la Misión de Cooperación Público Privada',  'Ejecución de la Misión de Cooperación Público Privada'),
        (25,  'Metodología de Generación Equipo de Trabajo Público Privado',  'Metodología de Generación Equipo de Trabajo Público Privado que promueva y difunda cambios de conducta en un sector productivo, proponga mejoramiento s de normativa, instrumentos, políticas o regulación de una actividad, o comprometa instancias de colaboración y coordinación público privada orientadas a resolver un problema que justifique la realización del proyecto.'),
        (26,  'Estudio de Mercado', 'Estudio de Mercado'),
        (27,  'Campaña de Promoción', 'Campaña de Promoción'),
        (28,  'Programas o Mensajes en Medios de Comunicación', 'Programas o Mensajes en Medios de Comunicación'),
        (29,  'Producción Audiovisual', 'Producción Audiovisual'),
        (30,  'Insertos en Medios Escritos',  'Insertos en Medios Escritos'),
        (31,  'Afiches',  'Afiches'),
        (32,  'Otros Objetos Comunicacionales', 'Otros Objetos Comunicacionales'),
        (33,  'Taller, Congreso, Seminario u Otros Eventos',  'Taller, Congreso, Seminario u Otros Eventos para presentar ejemplos demostrativos de beneficios ambientales y económicos obtenidos por la aplicación de medidas de PL, TL o Innovaciones Tecnológicas'),
        (34,  'Concursos y reconocimientos',  'Realización de Concursos u otras formas de reconocimiento de iniciativas conducentes a resultados con enfoque de PL, uso eficiente de recursos o prevención de la contaminación.'),
        (35,  'Actividades Comprometidas en el APL Terrritorial', 'Cofinanciar parte de las acciones comprometidas tales como prácticas y tecnologías limpias.'),
        (36,  'Mecanismos de acompañamiento y evaluación del cumplimiento de las acciones.',  'Mecanismos de acompañamiento y evaluación del cumplimiento de las acciones.'),
        (37,  'Actividades para consolidar modelo de gobernanza y capacidad de gestión de las entidades firmantes.',  'Actividades para Consolidar modelo de gobernanza y capacidad de gestión de las entidades firmantes.'),
        (38,  'Informe diagnóstico socioambiental', 'El Informe de diagnóstico socioambiental contiene una recopilación y sistematización de información sobre las características generales del territorio y posee la siguiente estructura. A Introducción Presenta el marco del programa, las características y contenidos del informe. Detallar su objetivo y la metodología utilizada en la colecta de información. B Caracterización socio ambiental del territorio De carácter descriptivo, es decir se debe relatar la información recogida, explicitando fuentes de recopilación de información, en los siguientes ámbitos: Situación socio-ambiental: Se sugiere realizar una breve descripción, a modo de línea base situacional, de la localidad considerando aquellos aspectos tradicionales mínimos: características geográficas, demográficas, antropológica, socioeconómicas y  bienestar social; Ordenamiento territorial: Instrumentos de planificación existente (plan regulador) u otros que permitan  caracterizar el territorio desde: el uso del suelo, infraestructura disponible, y otros; Actividad productiva y sus impactos: Describir la “vocación productiva” del territorio (El estudio de industrias, empresas y otros proyectos que estén presentes en el territorio o hayan ingresado al SEIA). Parece relevante indicar acá los principales impactos ambientales generados por las diversas industrias o actividades existentes.  C Acerca del Proyecto y la empresa Antecedentes generales de la problemática ambiental vinculada con el Proyecto o industria específica; Breve Caracterización empresa, antecedentes generales, señalar su historia en la comuna, principales aportes y problemas ambientales o eventuales conflictos con la comunidad. D Análisis de la situación socioambiental del territorio y principales hallazgos. Capítulo clave, ya que permitirá tener una visión general del desarrollo del territorio. A su vez, permitirá mostrar sinergias, brechas, oportunidades, dificultades, etc. Es decir, estos hallazgos, deben ser complementados con la percepción de los actores y, desde ahí, proponer el Plan de Participación. E Conclusiones'),
        (39,  'Informe caracterización de actores e interese (Mapa de actores)',  'Esta herramienta contribuye a identificar personas, grupos y organizaciones y sus intereses en el territorio. Asimismo, permite identificar sus necesidades, preocupaciones y las expectativas en relación con el proyecto que busca desarrollarse en el territorio. En especial, se busca identificar a aquellos actores que es necesario convocar para que se involucren de manera efectiva en el proceso participativo. El objetivo del mapa es levantar información actualizada y detallada para así identificar a los grupos interesados y a los actores del territorio, incluyendo su perfil sociocultural, sus intereses y posibles afectaciones en relación con el proyecto, además de su disposición y capacidad de involucrarse en el proceso participativo.'),
        (40,  'Acta/ minuta constitución de la mesa de Trabajo',  'Acta/ minuta constitución de la mesa de Trabajo'),
        (41,  'Documento Diseño Plan de Participación', 'Documento Diseño Plan de Participación'),
        (42,  'Registro y sistematización implementación Plan de Participación',  'Registro y sistematización implementación Plan de Participación'),
        (43,  'Minutas y presentaciones', 'Minutas y presentaciones'),
        (44,  'Propuesta final del documento de Acuerdo.',  'Propuesta final del documento de Acuerdo.'),
        (45,  'Documento con problemas y desafíos agrupados por ejes temáticos y consensuados por los participantes.',  'Documento con problemas y desafíos agrupados por ejes temáticos y consensuados por los participantes.'),
        (46,  'Mapa colaborativo priorizado.',  'Mapa colaborativo priorizado.'),
        (47,  'Planes Locales', 'Planes Locales'),
        (49,  'Ceremonia de firma', 'Ceremonia de firma');

      SELECT SETVAL('actividades_id_seq', (SELECT MAX(id) FROM actividades));
    SQL
  end
end
