class CreateTareas < ActiveRecord::Migration[5.1]
  def change
    create_table :tareas do |t|
      t.integer :etapa_id
      t.integer :tipo_instrumento_id, null: false
      t.integer :rol_id, null: false
      t.integer :encuesta_id
      t.string :nombre, null: false
      t.text :descripcion
      t.string :recordatorio_tarea_asunto
      t.text :recordatorio_tarea_cuerpo
      t.string :recordatorio_tarea_frecuencia
      t.boolean :posee_formulario
      t.boolean :cualquiera_con_rol_o_usuario_asignado
      t.text :condicion_de_acceso
      t.boolean :es_una_encuesta, default: false, null: false
      t.string :codigo
    end
    add_index :tareas, :codigo
    add_foreign_key :tareas, :etapas
    add_foreign_key :tareas, :tipo_instrumentos
    add_foreign_key :tareas, :roles
  end
  
  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "tareas" ("id", "etapa_id", "tipo_instrumento_id", "rol_id", "nombre", "descripcion", "recordatorio_tarea_asunto", "recordatorio_tarea_cuerpo", "recordatorio_tarea_frecuencia", "posee_formulario", "cualquiera_con_rol_o_usuario_asignado", "condicion_de_acceso", "es_una_encuesta", "encuesta_id", "codigo") VALUES
        (1, NULL, 5,  1,  'APL-001-Completar Manifestación de Interés', 'Quien propone el acuerdo presenta un formulario en cual se describe y justifica la idea de realizar un acuerdo.',  '', '', '', 't',  'f',  NULL, 'f',  NULL, 'APL-001'),
        (2, NULL, 10, 25, 'FPL-001-Revisar registro postulaciones y cargar nuevos proyectos ',  'Tarea automatizada que consiste en ir a servidor de FPL y extraer proyectos que podrían haber iniciado su seguimiento.', '', '', '', 'f',  'f',  NULL, 'f',  NULL, 'FPL-001'),
        (3, NULL, 10, 19, 'FPL-015-Propone modificación de calendario', 'Usuario solicita una modificación de las actividades planificadas en el proyecto en ejecución.', '', '', '', 't',  't',  NULL, 'f',  NULL, 'FPL-015'),
        (4, NULL, 10, 26, 'FPL-002-Iniciar seguimiento de proyectos', 'Seleccionar proyectos que inician ejecución a partir de lista de aprobados o con recomendación en sistema postulación del Fondo de Producción Limpia.',  'FPL-002-Iniciar seguimiento de proyectos.  Estimado/a, por favor indicar si nuevos proyectos del Fondo de Producción Limpia han Iniciado su Implementación', 'El formulario para ello puede ser accedido desde https://accion.ascc.cl/seguimiento_fpl/proyectos

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '8 8 */15 * *', 't',  'f',  NULL, 'f',  NULL, 'FPL-002'),
        (5, NULL, 10, 9,  'FPL-016-Aprueba y/o realiza modificación de calendario', 'Usuario aprueba cambios presentados o realiza modificaciones a calendario',  '', '', '', 't',  'f',  NULL, 'f',  NULL, 'FPL-016'),
        (6, NULL, 10, 26, 'FPL-018-Ingreso datos restitución',  'Usuario debe Ingresar los datos de pago de la restitución de fondos a la ASCC por modificaciones de proyecto .', 'FPL-018-Ingreso datos restitución',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  'f',  NULL, 'f',  NULL, 'FPL-018'),
        (7, NULL, 10, 27, 'FPL-003-Gestionar y registrar garantías y endosos',  'Usuario puede indicar datos de vencimiento boletas y montos o agregar endosos y señalar si boleta fue devuelta o cobrada.',  '', '', '', 't',  'f',  NULL, 'f',  NULL, 'FPL-003'),
        (8, NULL, 10, 25, 'FPL-004-Revisar plazos y montos',  'Sistema revisa los Plazos Contratos, Garantías y Entregas y realiza notificaciones de vencimiento inminente, vencimiento ocurrido, incoherencias entre plazos y montos a usuario acorde.', '', '', '', 'f',  'f',  NULL, 'f',  NULL, 'FPL-004'),
        (9, NULL, 10, 9,  'FPL-005-Designar responsables',  'Usuario debe designar responsable proyecto, responsable entregables, revisor entregables, indicar fecha de inicio y finalización del contrato, asignar centro de costos y adjuntar documentos de con resolución y contrato ',  'FPL-005-Designar responsables.', 'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  'f',  NULL, 'f',  NULL, 'FPL-005'),
        (10,  NULL, 10, 7,  'FPL-006-Agendar reunión con beneficiario y encargados entregables',  'Usuario debe enviar un correo a beneficiario para una reunión administrativa sobre el seguimiento del proyecto. Esta tarea queda activa mientras no exista registro de que se haya efectuado la reunión.', 'FPL-006-Agendar reunión con beneficiario y encargados entregables.', 'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'FPL-006'),
        (11,  NULL, 10, 26, 'FPL-017-Cargar resolución con contrato que aprueba modificación',  'Usuario debe cargar los nuevos plazos especificados en contrato así como la resolución que aprueba el contrato.',  'FPL-017-Cargar resolución con contrato que aprueba modificación',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl, ahí encontrará además un documento tipo para ello.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  'f',  NULL, 'f',  NULL, 'FPL-017'),
        (12,  NULL, 10, 7,  'FPL-007-Calendarizar rendiciones y carga de respaldo.',  'Usuario carga los detalles de las rendiciones a realizar y carga de acta de reunión. Incluye validación de reglas de Negocio.',  'FPL-007-Calendarizar rendiciones y carga de respaldo.',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'FPL-007'),
        (13,  NULL, 10, 26, 'FPL-008-Solicitar pago', 'Usuario realiza solicitudes de pago para proyectos en ejecución. (Validación Monto por Garantías, Rendición y Transferencias Realizadas)', 'FPL-008-Solicitar pago. Estimado/a, por favor indicar si es necesario realizar pagos a proyectos del Fondo de Producción Limpia',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '8 8 */15 * *', 't',  'f',  NULL, 'f',  NULL, 'FPL-008'),
        (14,  NULL, 10, 28, 'FPL-009-Ingresar N° orden de pago',  'Usuario ingresa n° de orden de pago asociado al pago solicitado.', 'FPL-009-Ingresar N° orden de pago',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  'f',  NULL, 'f',  NULL, 'FPL-009'),
        (15,  NULL, 10, 29, 'FPL-010-Ingresar fecha de pago', 'Usuario ingresa fecha para ejecución efectiva de orden de pago', 'FPL-010-Ingresar fecha de pago.',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  'f',  NULL, 'f',  NULL, 'FPL-010'),
        (16,  NULL, 10, 19, 'FPL-011-Enviar rendición', 'Permite a usuario hacer las rendiciones correspondientes a las actividades realizadas asociadas con el proyecto en cuestión.', 'FPL-011-Enviar rendición. Estimado/a, recordar realizar las rendiciones de proyecto.', 'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '8 8 */15 * *', 't',  't',  NULL, 'f',  NULL, 'FPL-011'),
        (17,  NULL, 10, 2,  'FPL-012-Revisar técnicamente rendición de actividades',  'Usuario con rol realiza la revisión técnica de las rendiciones enviadas, pudiendo aceptarlas o rechazarlas con observaciones.',  'FPL-012-Revisar técnicamente rendición de actividades',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'FPL-012'),
        (18,  NULL, 10, 30, 'FPL-013-Verificación contable',  'Usuario con rol realiza la revisión contable de las rendiciones enviadas, pudiendo aceptarlas o rechazarlas con observaciones.', 'FPL-013-Verificación contable',  'El formulario para ello puede ser accedido desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,', '30 8 * * 1',  't',  'f',  NULL, 'f',  NULL, 'FPL-013'),
        (19,  NULL, 10, 11, 'FPL-014-Responder Encuestas',  'Usuarios responden a preguntas asociadas a la ejecución del proyecto, el desempeño del equipo de trabajo y otras.',  'FPL-014-Responder Encuestas. Estimado/a, se le ruega evaluar responder la encuesta sobre la ejecución del proyecto.',  'Porque su opinión es importante para nosotros, nos interesa conocerla.

        Puede acceder a al formulario para efectuar dicha evaluación desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  'f',  NULL, 'f',  NULL,  'FPL-014'),
        (20,  NULL, 1,  1,  'PPF-001-Formular proyecto',  'Permite al usuario ingresar toda la información relevante para la creación de un Proyecto de Financiamiento.', '', '', '', 't',  'f',  NULL, 'f',  NULL, 'PPF-001'),
        (21,  NULL, 1,  11, 'PPF-024-Responder Encuesta final sobre ejecución programa/proyecto', 'Usuarios responden a preguntas asociadas a la ejecución del proyecto, el desempeño del equipo de trabajo y otras.',  'Estimado/a [nombre destinatario], se le ruega evaluar la ejecución de [Nombre Instrumento]', 'Estimado/a [nombre destinatario], se le ruega evaluar la ejecución de [Nombre Instrumento] de [Nombre SubTipo Instrumento].

        Puede efectuar dicha evaluación en la URL [Enlace a Formulario], quedan [días restantes] días para realizar la evaluación.

        Para ayudarle en su evaluación, los resultados de este programa/proyecto puede encontrarlos en: [Enlace a Respaldos rendiciones por Actividad]

        Cordialmente,
        Sistema Informático de Soporte de la Gestión
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'PPF-024'),
        (22,  NULL, 1,  11, 'PPF-023-Responder Encuesta de mitad de ejecución programa/proyecto', 'Usuarios responden a preguntas asociadas a la ejecución del proyecto, el desempeño del equipo de trabajo y otras.',  'Estimado/a [nombre destinatario], se le ruega evaluar la ejecución de [Nombre Instrumento]', 'Estimado/a [nombre destinatario], se le ruega evaluar la ejecución de [Nombre Instrumento] de [Nombre SubTipo Instrumento].

        Puede efectuar dicha evaluación en la URL [Enlace a Formulario], quedan [días restantes] días para realizar la evaluación.

        Para ayudarle en su evaluación, los resultados de este programa/proyecto puede encontrarlos en: [Enlace a Respaldos rendiciones por Actividad]

        Cordialmente,
        Sistema Informático de Soporte de la Gestión
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'PPF-023'),
        (23,  NULL, 1,  9,  'PPF-002-Designar revisor', 'Usuario designa Revisor Técnico para propuesta de Programa o Apoyo de Agencia a Programa.',  'Estimado/a [nombre destinatario], debe asignar responsable de revisar el [Nombre Instrumento] de [Nombre SubTipo Instrumento].', 'Estimado/a [nombre destinatario], debe asignar responsable de revisar el [Nombre Instrumento] de [Nombre SubTipo Instrumento].

        Puede realizar esto en la URL [Enlace a Formulario]

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  'f',  NULL, 'f',  NULL, 'PPF-002'),
        (24,  NULL, 1,  2,  'PPF-003-Revisar Propuesta',  'Usuario debe revisar mérito de propuesta y asignar un coordinador a cargo de la misma.', 'Estimado/a [nombre destinatario], se le ruega evaluar la propuesta de [Nombre Instrumento] de [Nombre Subtipo Instrumento]', 'Estimado/a [nombre destinatario], debe asignar responsable de revisar el [Nombre Instrumento] de [Nombre SubTipo Instrumento].

        Puede realizar esto en la URL [Enlace a Formulario]

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'PPF-003'),
        (25,  NULL, 1,  1,  'PPF-004-Resolver observaciones propuesta programa / proyecto', 'Usuario resuelve observaciones realizadas a sus propuestas.',  'Estimado/a [nombre destinatario], se le ruega resolver las observaciones realizadas a [Nombre Instrumento] de [Nombre Subtipo Instrumento]', 'Estimado/a [nombre destinatario], se le ruega resolver las observaciones realizadas a [Nombre Instrumento] de [Nombre Subtipo Instrumento]

        Puede realizar esto en la URL [Enlace a Formulario]

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'PPF-004'),
        (26,  NULL, 2,  7,  'PPF-005-Subir carta de apoyo', 'Usuario descarga el formato tipo de la carta de apoyo para el proyecto y gestiona su firma.',  'Estimado/a [nombre destinatario], se le ruega gestionar la firma y envío de la carta de apoyo de [Nombre Instrumento] de [Nombre Subtipo Instrumento]',  'Estimado/a [nombre destinatario], se le ruega gestionar la firma y envío de la carta de apoyo de [Nombre Instrumento] de [Nombre Subtipo Instrumento]

        Puede realizar esto en la URL [Enlace a Formulario]

        Para coordinar su recepción puede contactarse con [nombre cogestor][mail cogestor][fono cogestor]

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 * * 1', 't',  't',  NULL, 'f',  NULL, 'PPF-005'),
        (27,  NULL, 2,  7,  'PPF-006-Dar seguimiento a proyecto externo', 'Usuario debe ingresar datos que permiten hacer seguimiento al programa o proyecto apoyado por la agencia.',  'Estimado/a [nombre destinatario], se le ruega actualizar los datos de ejecución del proyecto apoyado por la agencia de [Nombre Instrumento] de [Nombre Subtipo Instrumento]',  'Estimado/a [nombre destinatario], se le ruega actualizar los datos de ejecución del proyecto apoyado por la agencia de [Nombre Instrumento] de [Nombre Subtipo Instrumento]

        Puede realizar esto en la URL [Enlace a Formulario]

        Para coordinar puede contactarse con [nombre cogestor][mail cogestor][fono cogestor]

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  '30 8 15 */4 *',  't',  't',  NULL, 'f',  NULL, 'PPF-006'),
        (28,  NULL, 1,  19, 'PPF-007-Elaborar Propuesta', 'Usuario debe cargar propuesta de Programa y/o Proyecto o resolver observaciones presentadas.', 'Estimado/a [nombre destinatario], se se le recuerda que debe cargar la propuesta de [Nombre Instrumento] de [Nombre Subtipo Instrumento]', 'Estimado/a [nombre destinatario], se se le recuerda que debe cargar la propuesta de [Nombre Instrumento] de [Nombre Subtipo Instrumento]

        Puede realizar esto en la URL [Enlace a Formulario]

        Para coordinar puede contactarse con [nombre proponente][mail proponente][fono proponente] [nombre cogestor][mail cogestor][fono cogestor].', '30 8 15 */4 * c',  't',  't',  NULL, 'f',  NULL, 'PPF-007');
      SELECT SETVAL('tareas_id_seq', (SELECT MAX(id) FROM tareas));
    SQL
  end
end