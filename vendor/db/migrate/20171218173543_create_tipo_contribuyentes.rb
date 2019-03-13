class CreateTipoContribuyentes < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_contribuyentes do |t|
      t.integer :tipo_contribuyente_id
      t.string :nombre, null: false
      t.text :descripcion
    end
    add_foreign_key :tipo_contribuyentes, :tipo_contribuyentes
  end

  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "tipo_contribuyentes" ("id", "tipo_contribuyente_id", "nombre", "descripcion") VALUES
			(1,	NULL,	'Persona Natural',	'Institución es una persona'),
			(2,	1,	'Persona Natural Chilena',	'Persona Natural Chilena'),
			(3,	1,	'Extranjero Con Residencia',	'Extranjero Con Residencia.'),
			(4,	1,	'Persona Natural Extranjera Nacionalizada',	'Persona Natural Extranjera Nacionalizada.'),
			(5,	1,	'Extranjeros Sin Residencia',	'Extranjeros Sin Residencia.'),
			(6,	NULL,	'Sin Personalidad Juridica',	'Sin Personalidad Juridica'),
			(7,	6,	'Sociedades De Hecho',	'Una Sociedad de Hecho se define como aquella que, teniendo todos los elementos de existencia y validez de una sociedad regular (recordando además que una sociedad es aquella que está compuesta de socios y encaminada a un objetivo), no tiene escritura pública; o bien debido a que los socios, siendo conscientes de haber creado la sociedad, no la han querido elevar a escritura pública, o bien porque la misma está en trámite. También será así entendida en caso de que aún cuando éstos jamás pensaron en constituir una sociedad, actuaron entre sí y ante terceros bajo dicho modo.'),
			(8,	6,	'Comunidades De Edificios',	'Entidad a cargo de la administración de un edificio.'),
			(9,	6,	'Sucesiones o Comunidades Hereditarias',	'La comunidad hereditaria es la situación de cotitularidad hereditaria que se crea con la posibilidad de una delación conjunta y simultánea a varios herederos que acepten la herencia deferida a su favor.'),
			(10,	6,	'Otras Organizaciones Sin Personalidad Jurídica',	'Otras Organizaciones Sin Personalidad Jurídica.'),
			(11,	6,	'Comunidad Disolución Sociedad Conyugal',	'Disuelta la sociedad conyugal se forma una comunidad entre los cónyuges que debe ser liquidada, siguiendo para ello las reglas de la partición.'),
			(12,	NULL,	'Persona Juridica Comercial',	'Persona Juridica Comercial'),
			(13,	12,	'Sociedades Anonimas Cerradas',	'La sociedad anónima es una persona jurídica que se origina por la constitución de un patrimonio único aportado por los accionistas. La responsabilidad de los accionistas se limita al monto de sus aportes individuales.  Las cerradas sociedades anónimas no se transan en mercados de valores y tienen que acudir necesariamente a instituciones financieras privadas como por ejemplo, capitalistas de riesgo, para obtener la inyección de capital que necesitan y  poseen un límite de accionistas.'),
			(14,	12,	'Sociedad de Responsabilidad Limitada',	'Una sociedad de responsabilidad limitada (SRL) o sociedad limitada (SL) es un tipo de sociedad mercantil en la cual la responsabilidad está limitada al capital aportado, y por lo tanto, en el caso de que se contraigan deudas, no responde con el patrimonio personal de los socios, sino al aportado en dicha empresa.'),
			(15,	12,	'Empresa Individual de Responsabilidad Limitada',	'Las Empresas Individuales de Responsabilidad Limitada (EIRL) son personas jurídicas, formadas exclusivamente por una persona natural, con patrimonio propio y distinto al del titular, que realizan actividades de carácter netamente comercial.'),
			(16,	12,	'Socieda Colectiva Civil',	'Son sociedades reguladas por el Código Civil Chileno, con contratos consensuales por cuanto la ley no establece solemnidades. En Sociedades Colectivas Civiles los socios responden hasta con su patrimonio personal, la cuota del insolvente grava a los demás socios y los acuerdos por regla general se toman por unanimidad.'),
			(17,	12,	'Sociedad por Acciones',	'Las Sociedades por Acciones (SpA) son un tipo de sociedad de capital caracterizada por su flexibilidad: otorga a los accionistas la facultad de regular libremente la casi totalidad de los aspectos de la sociedad. El rasgo jurídico más relevante de estas sociedades consiste en que ella puede tener originariamente o derivativamente un solo accionista.
			El artículo 424 del Código de Comercio que define estas sociedades, señala que “La sociedad por acciones (…) es una persona jurídica creada por una o más personas mediante un acto de constitución perfeccionado (...) cuya participación en el capital es representada por acciones”.'),
			(18,	12,	'Sociedades Anonimas Abiertas',	'Sociedad Anónima (S.A.), Cerrada y Abierta. La sociedad anónima es una persona jurídica que se origina por la constitución de un patrimonio único aportado por los accionistas. La responsabilidad de los accionistas se limita al monto de sus aportes individuales. Las Sociedades Anónimas Abiertas tienen que estar inscritas en la Bolsa de Comercio, y además ser supervisadas trimestralmente por a Superintendencia de Valores y Seguros mientras que las Cerradas no tienen obligación alguna de dar a conocer al público, nada que tenga que ver con su situación financiera.'),
			(19,	12,	'Encomanditas Por Acciones',	'La Sociedad en Comandita, es aquella que se celebra entre una o más personas que prometen llevar a la sociedad un determinado aporte, y una o más personas que se obligan a administrar exclusivamente la sociedad por sí o por sus delegados, y en nombre en partícular. Estas sociedades pueden clasificarse en simples o por acciones.

			Sociedad en Comandita por Acciones: se constituye por la reunión de un capital dividido en acciones o cupones de acción y suministrado por socios cuyo nombre no figura en la escritura social.'),
			(20,	12,	'Fondo De Inversion Privado',	'Fondos que se forman por aportes de personas o entidades, que son administrados por Sociedades Anónimas Cerradas, por cuenta y riesgo de sus aportantes y que no hacen oferta pública de sus valores.'),
			(21,	12,	'Sociedad Plataforma Artículo 41 D',	'SOCIEDAD PLATAFORMA SUJETA AL RÉGIMEN ESPECIAL DEL ARTÍCULO 41 D DE LA LEY DE IMPUESTO A LA RENTA.'),
			(22,	12,	'Sociedad Colectiva Comercial',	'La sociedad colectiva es una sociedad personalista que desarrolla una actividad mercantil bajo una razón social, con la peculiaridad de que los socios responden de forma subsidiaria del cumplimiento de las deudas sociales de manera personal, ilimitada y solidariamente.'),
			(23,	12,	'Sociedad Legal Minera',	'Sociedad Legal Minera.'),
			(24,	12,	'Fondo De Inversion Publico',	'Fondos de Inversión con a lo menos 50 partícipes, salvo que entre éstos haya un inversionista institucional, en cuyo caso no regirá ese número mínimo de partícipes. Del mismo modo, deberá mantener un patrimonio no menor al equivalente  a 10.000 unidades de fomento. La administradora lleva un Registro de Partícipes.'),
			(25,	12,	'Sociedad Anónima Deportiva',	'Sociedad Anónima Deportiva.'),
			(26,	12,	'Encomandita Simple',	'La Sociedad en Comandita, es aquella que se celebra entre una o más personas que prometen llevar a la sociedad un determinado aporte, y una o más personas que se obligan a administrar exclusivamente la sociedad por sí o por sus delegados, y en nombre en partícular. Estas sociedades pueden clasificarse en simples o por acciones.

			Sociedad en Comandita Simple: se forma por la reunión de un fondo que suministran en su totalidad uno o más socios comanditarios, o por éstos y los socios gestores a la vez.'),
			(27,	12,	'Sociedad Anonima Con Garantia Reciproca',	' SGR constituye un tipo especial de sociedad sin fines de lucro, que se rige principalmente por las normas de las sociedades anónimas -sin serlo- y que se caracteriza además por presentar un marcado carácter mutualista de cara a los derechos y obligaciones de sus socios. Se trata, en concreto, de un tipo societario específico y autónomo, un híbrido entre la sociedad capitalista y la sociedad mutualista integrado por pequeños y medianos empresarios que se asocian entre sí para mejorar sus expectativas de financiamiento a través de garantías o avales que les otorga la propia sociedad, sin posibilidad de que accedan a tales beneficios terceros extraños a ella. '),
			(28,	12,	'Companias De Seguro',	'Las Compañías de Seguros Generales son empresas que ofrecen seguros que cubren el riesgo de pérdida o deterioro en las cosas o en el patrimonio. En forma excepcional, también cubren los riesgos de accidentes personales y los seguros de salud. También pueden dedicarse a la intermediación y liquidación de seguros.'),
			(29,	12,	'Administradora Fondos De Pensiones',	'Las administradoras de fondos de pensiones (AFP) de Chile son instituciones financieras privadas encargadas de administrar los fondos de cuentas individuales de ahorros para pensiones.'),
			(30,	12,	'Bancos',	'Entidades que se organizan de acuerdo a leyes especiales y que se dedican a trabajar con el dinero, para lo cual reciben y tienen a su custodia depósitos hechos por las personas y las empresas, y otorgan préstamos usando esos mismos recursos, actividad que se denomina intermediación financiera.'),
			(31,	NULL,	'Organizaciones Sin Fines De Lucro',	'Organizaciones Sin Fines De Lucro'),
			(32,	31,	'Otra Organización sin fin de Lucro',	'Otra Organización sin fin de Lucro'),
			(33,	31,	'Junta de Vecinos, Organizaciones Comunitarias',	'Aquella con  personalidad jurídica y sin fines de lucro, que tenga por objeto representar y promover valores e intereses específicos de la comunidad dentro del territorio de la comuna o agrupación de comunas respectiva.'),
			(34,	31,	'Fundacion',	'Una fundación es un tipo de persona jurídica que se caracteriza por ser una organización sin ánimo o fines de lucro. Dotada con un patrimonio propio otorgado por sus fundadores, la fundación debe perseguir los fines que se contemplaron en su objeto social, si bien debe también cuidar de su patrimonio como medio.'),
			(35,	31,	'Cooperativa',	'Son asociaciones autónomas de personas que se han unido voluntariamente para hacer frente a sus necesidades y aspiraciones económicas, sociales y culturales.'),
			(36,	31,	'Club Deportivo',	'Un club deportivo, club de deportes o club atlético, es un club dedicado a la práctica del deporte.'),
			(37,	31,	'Asociación Gremial',	'Una asociación gremial es una organización que promueve el desarrollo, protección y establecimiento de normas de los procesos de las actividades profesionales o de oficio que realizan sus integrantes.'),
			(38,	31,	'Corporacion',	'Una corporación es un grupo de personas autorizadas para operar como una sola entidad (persona jurídica) y reconocida como tal ante la ley. '),
			(39,	31,	'Sindicato',	'Sindicato.'),
			(40,	31,	'Entidad Individual Educacional Ley 20845',	'Personas jurídicas de derecho privado sin fines de lucro, con personalidad jurídica y patrimonio propio, distinto al del titular, cuyo objeto único será la educación.'),
			(41,	31,	'Corporacion Educacional Ley 20845',	'Son corporaciones educacionales las personas jurídicas de derecho privado sin fines de lucro constituidas por dos o más personas naturales, debidamente registradas ante la autoridad, cuyo objeto único sea la educación, y que se regirán por las disposiciones de la ley 20845 y, de manera supletoria, por las disposiciones del Título XXXIII del Libro I del Código Civil.'),
			(42,	NULL,	'Sociedades Extranjeras',	'Sociedades Extranjeras'),
			(43,	42,	'Entidad Sin Residencia',	'Entidades sin personalidad jurídica que carecen de domicilio o residencia en nuestro país.'),
			(44,	42,	'Agencia',	'Sociedad o persona jurídica con fines de lucro de origen extranjero.'),
			(45,	42,	'Sociedad Extranjera Res 5412/2000',	'Sociedad Extranjera ajustada a Resolución 5412/2000'),
			(46,	NULL,	'Instituciones Fiscales',	'Instituciones Fiscales'),
			(47,	46,	'Organismo de la Administración Publica',	'Organismo fiscal dependiente del poder ejecutivo.'),
			(48,	46,	'Ministerios',	'Ministerios.'),
			(49,	46,	'Organismos del Ministerio Salud',	'Organismos dependientes del Ministerio Salud'),
			(50,	46,	'Organismos de Educación Superior',	'Comprende a las Universidades creadas por Ley en las cuales el Estado tiene participación ya sea en su generación o administración. Este grupo se compone de 16 Universidades.'),
			(51,	46,	'Organismos del Ministerio Justicia',	'Organismos dependientes del poder judicial.'),
			(52,	46,	'Organismo Autonomo Del Estado',	'Otros Organismos del Estado que no dependen del poder ejecutivo.'),
			(53,	46,	'Organismos Ministerio Defensa',	'Organismos del Ministerio de Defensa.'),
			(54,	NULL,	'Municipalidades',	'Municipalidades'),
			(55,	54,	'Municipalidad',	'Municipalidades.'),
			(56,	54,	'Liceo O Colegio Municipal',	'Liceo o Colegio Municipal.'),
			(57,	54,	'Otro Organismo Municipal',	'Otros Organismos Municipales.'),
			(58,	NULL,	'Organismos Internacionales',	'Organismos Internacionales'),
			(59,	58,	'Organismos Internacionales',	'Organismos Internacionales.'),
			(60,	58,	'Embajadas',	'Residencia y oficina del embajador (el diplomático que representa a otro Estado en Chile).'),
			(61,	NULL,	'No Clasificados',	'No Clasificados'),
			(62,	61,	'No Clasificado',	'No Clasificados.');

		SELECT SETVAL('tipo_contribuyentes_id_seq', (SELECT MAX(id) FROM tipo_contribuyentes));
    SQL
  end
end
