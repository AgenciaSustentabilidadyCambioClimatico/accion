class CreateCargos < ActiveRecord::Migration[4.2]
	def change
		PostgresHelper.with_schema('public') do
			create_table :cargos do |t|
				t.string :nombre, null: false, limit: 50
				t.text :descripcion, null: false
				t.boolean :agencia, default: true
			end
			add_index :cargos, :nombre, unique: true
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
    	INSERT INTO "cargos" ("id", "nombre", "descripcion", "agencia") VALUES
				(1,	'Super Administrador',	'Este cargo es inmutable, no se puede editar; borrar; ni asignar a otro usuario. Adquiere permisos automáticamente cuando se crean y los pierde cuando éstos se borran.',	't'),
				(2,	'Administrador',	'Cargo para usuario administrador.',	't'),
				(3,	'Usuario',	'Cargo básico que accede al sistema. Sólo puede cambiar sus datos de cuenta',	't'),
				(4,	'Encargado(a) Atención a Usuarios',	'Cargo de la ASCC responsable de atender las necesidades básicas de los usuarios de la plataforma. Puede Agregar y modificar personas, instituciones, establecimientos, maquinaria, otros (pero no los ruts, nombres o identificadores únicos de estos, los datos tributarios, ni el alcance en otros) y además permite agregar o modificar cargos que no son de sistema. Ademas puede asignar, modificar o crear relaciones entre personas, cargos e instituciones, siempre y cuando no sean relaciones que involucren a la ASCC.',	't'),
				(5,	'Encargado(a) Control',	'Es el Cargo responsable del control y auditoría de la ASCC. Tiene acceso de ver a toda la plataforma, pero no puede editar nada.',	't'),
				(6,	'Encargado(a) Diseño Instrumentos',	'Cargo de la ASCC responsable del diseño y coherencia de los instrumentos de la misma. Puede administrar todo el menú contenido en Configuración de Tipo de Instrumento, puede visualizar el historial de acciones de cada instrumento, puede modificar cargos (no borrar ni crear), puede modificar tipo de contribuyente, pero no agregar ni borrar, puede modificar (agregar y borrar) metas, acciones, alcances de certificación, tipos de acción, clasificación de acciones, relaciones entre acciones; Actividades FPL, actividades económicas, lugares y proveedores.',	't'),
				(7,	'Encargado(a) Recursos Humanos',	'Es el cargo de la ASCC responsable del diseño de las políticas de recursos humanos y de que las contrataciones y desarrollo de carrera profesional se ajusten a lo requerido por la ASCC y sus instrumentos. Puede modificar, agregar o eliminar la relación entre personas, cargos y ASCC.',	't'),
				(8,	'Coordinador(a) de Acuerdos',	'Es responsable de la gestión de un Acuerdo una vez que la ASCC ha decidido realizarlo.',	't'),
				(9,	'Encargado(a) Comunicaciones',	'Cargo de la ASCC responsable de la gestión comunicacional, puede administrar todas las funcionalidades asociadas a hitos de prensa en la plataforma y es Jefe de Periodistas de la ASCC.',	't'),
				(10,	'Encargado(a) Desarrollo e Implementación de SIA',	'Responsable del desarrollo e implementación de plataformas tecnológicas de apoyo a los instrumentos. Cargo de la ASCC que administra esta plataforma.',	't'),
				(11,	'Dueño(a)',	'Dueño(a) de una institución, para efectos de sistema es un alias de Director(a) Ejecutivo(a).',	'f'),
				(12,	'Director(a) Ejecutivo(a) / Gerente General',	'Es la máxima autoridad de una institución. En las instituciones que no son la ASCC permite administrar todos los datos asociados a su institución, establecimientos, maquinaria y otros, así como asignar cargos y personas a su institución. No puede cambiar el rut de la institución, ni tipo de contribuyente, formulario de impuestos, ni tamaño de la empresa para un año en el que ya se ha fijado.',	'f'),
				(13,	'Representante Legal',	'Es la persona que legalmente representa a un institución. Para efectos del sistema es un alias de Director(a) Ejecutivo(a).',	'f'),
				(14,	'Encargado(a) Institución',	'Es la persona a cargo de la administración de una institución. Para efectos del sistema es un alias de Director(a) Ejecutivo(a).',	'f'),
				(15,	'Encargado(a) Establecimiento',	'Equivale a Encargado(a) de Sucursal o de Instalación. Este cargo otorga la facultad de administrar los establecimientos asignados, las maquinaria de dicho establecimiento y otros de dicho establecimiento, esto incluye definir qué datos son públicos o no, pero no puede modificar los identificadores únicos como RUT, patente, número de serie, calidad de casa matriz o la dirección.',	'f'),
				(16,	'Periodista',	'Un(a) Periodista de la ASCC se encarga de gestionar los hitos comunicacionales asociados a la ASCC y sus instrumentos. Puede administrar todas las funcionalidades asociadas a hitos de prensa en la plataforma.',	't'),
				(17,	'Secretario(a) Regional',	'Es un cargo de la ASCC equivalente a Encargado(a) de Establecimiento, representante de la ASCC en la región a la cual se encuentran destinados.',	't'),
				(18,	'Encargado(a) Gestión Financiera',	'A cargo de la gestión presupuestaria de la Institución. Para efectos de este sistema es quien carga el presupuesto a cada centro de costos.',	't'),
				(19,	'Coordinador(a) Nacional de APL',	'Persona a Cargo de la Coordinación Nacional de todos los Acuerdos de Producción Limpia.',	't'),
				(20,	'Encargado(a) Administrativa(o) FPL',	'Encargado(a) Administrativa(o) FPL',	't'),
				(21,	'Jefe de Contabilidad y Finanzas',	'Jefe de Contabilidad y Finanzas',	't'),
				(22,	'Encargado(a) de Finanzas',	'Encargado(a) de Finanzas',	't'),
				(23,	'Asistente Contabilidad',	'Asistente Contabilidad',	't'),
				(24,	'Subdirector(a) de Acuerdos de Producción Limpia',	'Subdirector(a) de Acuerdos de Producción Limpia',	't'),
				(25,	'Encargado(a) de Programas de Financiamiento',	'Encargado(a) de Programas y Proyectos de Financiamiento',	't'),
        (27,  'Coordinador(a) Regional',  'Es un posible responsable de la gestión regional de un Acuerdo una vez que la ASCC ha decidido realizarlo.', 't');

			SELECT SETVAL('cargos_id_seq', (SELECT MAX(id) FROM cargos));
    SQL
  end
end