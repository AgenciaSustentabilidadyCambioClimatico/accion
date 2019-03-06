class CreateFlujoTareas < ActiveRecord::Migration[5.1]
  def change
    create_table :flujo_tareas do |t|
      t.integer :tarea_entrada_id, null: false
      t.integer :tarea_salida_id
      t.boolean :sin_salida, default: false
      t.text :rol_destinatarios, null: false
      t.text :descripcion_flujo
      t.text :condicion_de_salida, null: false
      t.string :mensaje_salida_asunto
      t.text :mensaje_salida_cuerpo
    end
    add_foreign_key :flujo_tareas, :tareas, column: :tarea_entrada_id
    add_foreign_key :flujo_tareas, :tareas, column: :tarea_salida_id
  end
  
  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "flujo_tareas" ("id", "tarea_entrada_id", "tarea_salida_id", "rol_destinatarios", "condicion_de_salida", "mensaje_salida_asunto", "mensaje_salida_cuerpo", "sin_salida", "descripcion_flujo") VALUES
        (1, 4,  7,  '---
        - ''''
        - ''27''
        - ''26''
        ',  'A',  'FPL - Estimado/a, un nuevo proyecto ha iniciado su ejecución.',  'Si usted es el Encargado de Valores, puede acceder al formulario para manejar documentos de garantía desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Siempre que se selecciona un nuevo proyecto se abre la opción de gestionar los documentos de garantías.'),
        (2, 4,  9,  '---
        - ''''
        - ''3''
        - ''7''
        - ''26''
        - ''9''
        - ''19''
        ',  'B',  'FPL - Estimado/a, un nuevo proyecto ha iniciado su ejecución.',  'Si usted es el responsable del Fondo de Producción Limpia, puede acceder al formulario para asignar los responsables en https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.
        ',  'f',  'Siempre que se selecciona un nuevo proyecto se deben designar los responsables'),
        (3, 9,  10, '---
        - ''''
        - ''3''
        - ''7''
        - ''9''
        - ''19''
        ',  'A',  'FPL - Estimado/a, se han designado las contrapartes de un proyecto', 'Si usted es el Coordinador, desde  https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl puede ingresar al formulario para fijar una fecha y lugar para la reunión de inicio del proyecto.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Siempre que se han designado los responsables se debe agendar una reunión de inicio.'),
        (4, 10, 10, '---
        - ''''
        - ''7''
        ',  'A',  '', '', 'f',  'Mientras no se cargue el calendario con el acta de la reunión de inicio, siempre es posible modificar la fecha y lugar de dicha reunión.'),
        (5, 10, 12, '---
        - ''''
        - ''3''
        - ''7''
        - ''9''
        - ''19''
        ',  'B',  'FPL - Estimado/a, se ha agendado la reunión de inicio de proyecto el [fecha_reunion] en [lugar_reunion]',  'Si usted es el Coordinador, desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl puede ingresar al formulario para cargar los resultados de dicha reunión o para fijar una nueva fecha y un nuevo lugar para la reunión de inicio de este proyecto.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Siempre que se ha agendado una reunión de inicio se deben cargar los resultados de dicha reunión con el calendario de entrega.'),
        (6, 12, 13, '---
        - ''''
        - ''7''
        - ''26''
        ',  'A',  '', '', 'f',  'Siempre que se carga el calendario se incluye el proyecto en el panel de pagos, pudiéndose realizar si se cumplen las validaciones.'),
        (7, 12, 3,  '---
        - ''''
        - ''7''
        - ''19''
        ',  'B',  '', '', 'f',  'Siempre que se han calendarizado rendiciones y mientras aún queden actividades que no estén en proceso de rendición, rendidas o en modificación, se puede modificar el proyecto.'),
        (8, 12, 5,  '---
        - ''''
        - ''7''
        - ''9''
        ',  'C',  '', '', 'f',  'Siempre que se han calendarizado rendiciones y mientras aún queden actividades que no estén en proceso de rendición o rendidas, se puede modificar el proyecto.'),
        (9, 12, 16, '---
        - ''''
        - ''3''
        - ''7''
        - ''29''
        - ''9''
        - ''19''
        ',  'D',  'FPL - Estimado/a, Se ha establecido el calendario de ejecución y modalidades de pago de un proyecto',  'Dependiendo de sus permisos puede acceder a los formularios para rendición del proyecto, solicitar modificaciones al proyecto o ejecutar pagos del proyecto desde desde https://accion.ascc.cl/tareas-pendientes/seguimiento-fpl.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Siempre que se han calendarizado rendiciones y mientras aún queden actividades que no han sido aceptadas, se puede ingresar para enviar una rendición.'),
        (10,  13, 14, '---
        - ''''
        - ''26''
        - ''28''
        ',  'A',  'Asunto mensaje Tarea 8 a 9', 'Cuerpo mensaje Tarea 8 a 9', 'f',  NULL),
        (11,  13, 15, '---
        - ''''
        - ''29''
        - ''26''
        ',  'B',  'Asunto mensaje Tarea 8 a 10',  'Cuerpo mensaje Tarea 8 a 10',  'f',  NULL),
        (12,  16, 17, '---
        - ''''
        - ''19''
        - ''2''
        ',  'A',  'Asunto mensaje Tarea 11 a 12', 'Cuerpo mensaje Tarea 11 a 12', 'f',  NULL),
        (13,  17, 18, '---
        - ''''
        - ''30''
        - ''2''
        ',  'A',  'Asunto mensaje Tarea 12 a 13', 'Cuerpo mensaje Tarea 12 a 13', 'f',  NULL),
        (14,  17, 16, '---
        - ''''
        - ''19''
        - ''2''
        ',  'B',  'Asunto mensaje Tarea 12 a 11', 'Cuerpo mensaje Tarea 12 a 11', 'f',  NULL),
        (15,  18, 19, '---
        - ''''
        - ''11''
        - ''30''
        ',  'C',  'Asunto mensaje Flujo de Tarea 13 a Termino Flujo', 'Cuerpo mensaje Flujo de Tarea 13 a Termino Flujo', 'f',  NULL),
        (16,  18, 16, '---
        - ''''
        - ''3''
        - ''30''
        ',  'B',  'Asunto mensaje Tarea 13 a 11', 'Cuerpo mensaje Tarea 13 a 11', 'f',  NULL),
        (17,  19, NULL, '---
        - ''''
        - ''11''
        ',  'A',  'Asunto mensaje Tarea 14 a Término Flujo',  'Cuerpo mensaje Tarea 14 a Término Flujo',  't',  ''),
        (18,  3,  3,  '---
        - ''''
        - ''3''
        ',  'A',  'Asunto mensaje Tarea 15 a 15', 'Cuerpo mensaje Tarea 15 a 15', 'f',  NULL),
        (19,  3,  5,  '---
        - ''''
        - ''3''
        - ''9''
        ',  'B',  'Asunto mensaje Tarea 15 a 16', 'Cuerpo mensaje Tarea 15 a 16', 'f',  NULL),
        (20,  5,  NULL, '---
        - ''''
        - ''9''
        ',  'A',  'Asunto mensaje Tarea 16 a final flujo',  'Cuerpo mensaje Tarea 16 a final flujo',  't',  ''),
        (21,  5,  11, '---
        - ''''
        - ''26''
        - ''9''
        ',  'B',  'Asunto mensaje Tarea 16 a 17', 'Cuerpo mensaje Tarea 16 a 17', 'f',  NULL),
        (22,  5,  6,  '---
        - ''''
        - ''26''
        - ''9''
        ',  'C',  'Asunto mensaje Tarea 16 a 18', 'Cuerpo mensaje Tarea 16 a 18', 'f',  NULL),
        (24,  11, NULL, '---
        - ''''
        - ''26''
        ',  'A',  'Asunto mensaje de Tarea 17 a Finaliza flujo',  'Cuerpo mensaje de Tarea 17 a Finaliza flujo',  't',  ''),
        (25,  6,  NULL, '---
        - ''''
        - ''26''
        ',  'A',  'Asunto mensaje de Tarea 18 a Finaliza flujo',  'Cuerpo mensaje de Tarea 18 a Finaliza flujo',  't',  ''),
        (27,  14, NULL, '---
        - ''''
        - ''28''
        ',  'A',  'Asunto mensaje Tarea 9 a Finaliza flujo',  'Cuerpo mensaje Tarea 9 a Finaliza flujo',  't',  ''),
        (28,  15, NULL, '---
        - ''''
        - ''29''
        ',  'A',  'Asunto mensaje Tarea 10 a Finaliza flujo', 'Cuerpo mensaje Tarea 10 a Finaliza flujo', 't',  ''),
        (31,  8,  8,  '---
        - ''''
        - ''3''
        - ''7''
        - ''9''
        - ''19''
        - ''25''
        ',  'A',  'FPL - CONTRATO VENCIDO', 'El contrato de un proyecto venció.

        El vencimiento de un contrato puede dar lugar a una investigación sumaria. Los registros de este sistema constituyen evidencia para dicha investigación.

        Cordialmente, 
        Sistema Informático de Soporte de la Gestión, 
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Regularmente sistema chequea que rendiciones, contratos y garantías se encuentren en plazo.'),
        (32,  8,  8,  '---
        - ''''
        - ''3''
        - ''7''
        - ''9''
        - ''19''
        - ''25''
        ',  'B',  'FPL - Contrato por vencer',  'Si usted es responsable de entregables, debe rendir los entregables pendientes o solicitar una modificación del proyecto que se ajuste a nuevos plazos. Ambos formularios pueden ser accedidos desde https://accion.ascc.cl/seguimiento_fpl/proyectos.

        Les recordamos que el vencimiento de un contrato constituye motivo para una investigación sumaria, y que los registros de este sistema constituyen evidencia para dicha investigación.

        Cordialmente, 
        Sistema Informático de Soporte de la Gestión, 
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Regularmente sistema chequea que rendiciones, contratos y garantías se encuentren en plazo.'),
        (33,  8,  NULL, '---
        - ''''
        - ''3''
        - ''7''
        - ''27''
        - ''9''
        - ''19''
        - ''25''
        ',  'C',  'FPL - GARANTÍA VENCIDA', 'La garantía de un proyecto venció.

        El vencimiento de una boleta de garantía puede dar lugar a una investigación sumaria. Los registros de este sistema constituyen evidencia para dicha investigación.

        Cordialmente, 
        Sistema Informático de Soporte de la Gestión, 
        Agencia de Sustentabilidad y Cambio Climático.',  't',  'Regularmente sistema chequea que rendiciones, contratos y garantías se encuentren en plazo.'),
        (34,  8,  NULL, '---
        - ''''
        - ''3''
        - ''7''
        - ''27''
        - ''9''
        - ''19''
        - ''25''
        ',  'D',  'FPL - Garantía pronta a vencer', 'Si usted es el beneficiario o cogestor debe extender el plazo de su documento de garantía o rendir la totalidad del proyecto antes de su vencimiento. Si usted es el encargado de valores, puede chequear el estado de las garantías desde https://accion.ascc.cl/seguimiento_fpl/proyectos.

        Les recordamos que el vencimiento de una boleta de garantía puede dar lugar a una investigación sumaria y que los registros de este sistema constituyen evidencia para dicha investigación. Por ella la boleta de garantía debe ser ejecutada de no finalizar el proyecto antes de su vencimiento o de no existir un endoso a la misma.

        Cordialmente, 
        Sistema Informático de Soporte de la Gestión, 
        Agencia de Sustentabilidad y Cambio Climático.',  't',  'Regularmente sistema chequea que rendiciones, contratos y garantías se encuentren en plazo.'),
        (35,  8,  8,  '---
        - ''''
        - ''25''
        ',  'E',  'FPL- Estimado, el plazo definido para entregar actividades se ha cumplido',  'Si usted es responsable de subir entregables, puede acceder al formulario de rendiciones desde  https://accion.ascc.cl/seguimiento_fpl/proyectos 

        Cordialmente, 
        Sistema Informático de Soporte de la Gestión, 
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Regularmente sistema chequea que rendiciones, contratos y garantías se encuentren en plazo.'),
        (36,  8,  8,  '---
        - ''''
        - ''3''
        - ''7''
        - ''9''
        - ''19''
        - ''25''
        ',  'F',  'FPL - Rendiciones con plazo para entrega pronto a cumplirse',  'Si usted es responsable de subir entregables, puede acceder al formulario de rendiciones desde https://accion.ascc.cl/seguimiento_fpl/proyectos 

        Cordialmente, 
        Sistema Informático de Soporte de la Gestión, 
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Regularmente sistema chequea que rendiciones, contratos y garantías se encuentren en plazo.'),
        (37,  7,  7,  '---
        - ''''
        - ''3''
        - ''27''
        - ''9''
        ',  'A',  'FPL- Datos de garantía han sido ingresados o modificados', 'En https://accion.ascc.cl/seguimiento_fpl/proyectos podrá ver si posee alguna tarea pendiente.

        Cordialmente,
        Sistema Informático de Soporte de la Gestión,
        Agencia de Sustentabilidad y Cambio Climático.',  'f',  'Siempre es posible volver a gestionar garantías mientras proyecto está en ejecución.'),
        (38,  7,  8,  '---
        - ''''
        - ''27''
        - ''25''
        ',  'B',  '', '', 'f',  'Desde que se ingresan datos de garantías sistema inicia chequeo de plazos'),
        (39,  18, NULL, '---
        - ''''
        - ''30''
        ',  'A',  'Asunto mensaje de Tarea 13 a final flujo', 'Cuerpo mensaje de Tarea 13 a final flujo', 't',  '');
      SELECT SETVAL('flujo_tareas_id_seq', (SELECT MAX(id) FROM flujo_tareas));
    SQL
  end
end