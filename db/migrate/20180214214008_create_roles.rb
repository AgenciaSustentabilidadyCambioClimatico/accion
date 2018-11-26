class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :nombre
      t.text :descripcion
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
    	INSERT INTO "roles" ("id", "nombre", "descripcion") VALUES
				(1,	'Proponente',	'Es aquel representante de instituciones o funcionario de la agencia que posee la potestad de presentar propuestas de realización de una instancia de un instrumento de la ASCC.'),
				(2,	'Revisor Técnico',	'Es el funcionario de la ASCC que posee el rol de revisar técnicamente los documentos que son presentados a la Agencia en el contexto de sus instrumentos.'),
				(3,	'Cogestor',	'En el contexto de un instrumento, es el rol asumido por una institución externa a la agencia que actuará como contraparte de la misma en la gestión de dicho instrumento.'),
				(4,	'Patrocinador',	'Es el rol asumido por un representante de una institución, en particular una autoridad que compromete apoyo no monetario a un instrumento.'),
				(5,	'Financista',	'Es el rol asumido por un representante de un entidad que ha comprometido recursos financieros para la ejecución de un instrumento'),
				(6,	'Prensa',	'Es el rol asumido por personas que pueden publicar noticias asociadas a una instancia de un instrumento en representación de entidades participantes del mismo.'),
				(7,	'Coordinador',	'Es el rol de gestión asumido por un funcionario de la agencia en la gestión de un instrumento cuya ejecución la misma ha decidido.'),
				(9,	'Jefe de Línea',	'Es el rol asumido por la gente designada por la Agencia como responsables de líneas y sublíneas de instrumentos. Son quienes pueden administrar instancias de los instrumentos o subtipos de instrumentos que poseen asignados.'),
				(11,	'Parte Interesada Relevante',	'Este es el rol asignado a aquellas instituciones y sus representantes que poseen interés en un Instrumento, y son relevantes para el mismo.'),
				(12,	'Firmante',	'Es el rol asumido por quien firma un acuerdo en representación de su institución.'),
				(13,	'Validador',	'Es el rol asumido por los representantes de aquellas instituciones que deben validar las auditorias de un Acuerdo.'),
				(14,	'Auditor',	'Es el rol asumido por un Auditor de un Acuerdo, solo puede tener este rol miembros de una institución que tengan vigente su estatus de auditor Acuerdo.'),
				(15,	'Negociador',	'Es el representante de una institución que participa en la negociación de las metas y acciones de un acuerdo en la etapa de Propuesta de Acuerdo.'),
				(16,	'Comité Coordinador',	'Es el representante de una institución que participa en la coordinación y seguimiento del cumplimiento de las metas y acciones de un acuerdo en las etapa de adhesión,  implementación y certificación de un Acuerdo.'),
				(17,	'Responsable Cumplimiento Compromisos',	'Representante de una Organización encargado de cumplir los compromisos adquiridos por la misma según los alcances y acciones definidos en el Acuerdo o Programa'),
				(18,	'Cargador Datos Acuerdo',	'Rol asumido por la persona encargada por parte de una institución designada para cargar datos productivos asociados a los elementos adheridos a un Acuerdo.'),
				(19,	'Responsable Entregables',	'Es el responsable de cargar los entregables asociados al instrumento.'),
				(22,	'Certificada',	'Rol que asume el representan te una institución que posee al menos un elemento certificado en el acuerdo.'),
				(25,	'Sistema',	'Rol asumido por el sistema para realización de tareas automatizadas.'),
				(26,	'Encargado de Gestión Administrativa',	'Rol asociado a Fondo PL que da inicio y gestiona los proyectos de seguimientos FPL.'),
				(27,	'Encargado Valores',	'Rol asociado a FPL, encargado de la gestión de documentos de garantías y endosos.'),
				(28,	'Encargado de Registro de Pagos',	'Rol encargado del registro de la información relevante de pagos por realizar'),
				(29,	'Encargado de Ejecución de Pagos',	'Rol en el que usuario ingresa información relevante sobre la ejecución de pagos.'),
				(30,	'Revisor Contable',	'Es el funcionario de la ASCC que posee el rol de revisar contablemente los documentos que son presentados a la Agencia en el contexto de sus instrumentos.');
			
			SELECT SETVAL('roles_id_seq', (SELECT MAX(id) FROM roles));
    SQL
  end
end