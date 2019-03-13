class Comuna < ApplicationRecord
	belongs_to :provincia

	def self.por_provincia_id
		comunas = {}
		Comuna.order(provincia_id: :desc, nombre: :asc).all.each do |comuna|
			comunas[comuna.provincia_id] = [] unless comunas.has_key?(comuna.provincia_id)
			comunas[comuna.provincia_id] << { id: comuna.id, nombre: comuna.nombre }
		end
		comunas
	end

	def self.__select provincia_id=nil, region_id=nil
		lista = []
		comunas = Comuna.order(nombre: :asc)
		unless provincia_id.nil?
			comunas = comunas.where(provincia_id: provincia_id)
		end
		if provincia_id.nil? && !region_id.nil?
			provincias_id = Provincia.where(region_id: region_id).pluck(:id)
			comunas = comunas.where(provincia_id: provincias_id)
		end
		comunas.map do |c|
			lista << [c.nombre, c.id]
		end
		
		lista
	# 	[
	# 		['Alto Hospicio',2],
	# 		['Camiña',4],
	# 		['Colchane',5],
	# 		['Huara',6],
	# 		['Iquique',1],
	# 		['Pica',7],
	# 		['Pozo Almonte',3],
	# 		['Antofagasta',8],
	# 		['Calama',12],
	# 		['María Elena',16],
	# 		['Mejillones',9],
	# 		['Ollagüe',13],
	# 		['San Pedro de Atacama',14],
	# 		['Sierra Gorda',10],
	# 		['Taltal',11],
	# 		['Tocopilla',15],
	# 		['Alto del Carmen',23],
	# 		['Caldera',18],
	# 		['Chañaral',20],
	# 		['Copiapó',17],
	# 		['Diego de Almagro',21],
	# 		['Freirina',24],
	# 		['Huasco',25],
	# 		['Tierra Amarilla',19],
	# 		['Vallenar',22],
	# 		['Andacollo',28],
	# 		['Canela',33],
	# 		['Combarbalá',37],
	# 		['Coquimbo',27],
	# 		['Illapel',32],
	# 		['La Higuera',29],
	# 		['La Serena',26],
	# 		['Los Vilos',34],
	# 		['Monte Patria',38],
	# 		['Ovalle',36],
	# 		['Paiguano',30],
	# 		['Punitaqui',39],
	# 		['Río Hurtado',40],
	# 		['Salamanca',35],
	# 		['Vicuña',31],
	# 		['Algarrobo',68],
	# 		['Cabildo',56],
	# 		['Calera',61],
	# 		['Calle Larga',52],
	# 		['Cartagena',69],
	# 		['Casablanca',42],
	# 		['Catemu',74],
	# 		['Concón',43],
	# 		['El Quisco',70],
	# 		['El Tabo',71],
	# 		['Hijuelas',62],
	# 		['Isla de Pascua',50],
	# 		['Juan Fernández ',44],
	# 		['La Cruz',63],
	# 		['La Ligua  ',55],
	# 		['Limache',64],
	# 		['Llaillay',75],
	# 		['Los Andes',51],
	# 		['Nogales',65],
	# 		['Olmué',66],
	# 		['Panquehue',76],
	# 		['Papudo',57],
	# 		['Petorca   ',58],
	# 		['Puchuncaví',45],
	# 		['Putaendo',77],
	# 		['Quillota',60],
	# 		['Quilpué',46],
	# 		['Quintero',47],
	# 		['Rinconada',53],
	# 		['San Antonio',67],
	# 		['San Esteban',54],
	# 		['San Felipe',73],
	# 		['Santa María',78],
	# 		['Santo Domingo',72],
	# 		['Valparaíso',41],
	# 		['Villa Alemana',48],
	# 		['Viña del Mar',49],
	# 		['Zapallar',59],
	# 		['Chépica',103],
	# 		['Chimbarongo',104],
	# 		['Codegua',80],
	# 		['Coinco',81],
	# 		['Coltauco',82],
	# 		['Doñihue',83],
	# 		['Graneros',84],
	# 		['La Estrella ',97],
	# 		['Las Cabras',85],
	# 		['Litueche',98],
	# 		['Lolol',105],
	# 		['Machalí',86],
	# 		['Malloa',87],
	# 		['Marchihue',99],
	# 		['Mostazal',88],
	# 		['Nancagua',106],
	# 		['Navidad    ',100],
	# 		['Olivar',89],
	# 		['Palmilla',107],
	# 		['Paredones',101],
	# 		['Peralillo',108],
	# 		['Peumo',90],
	# 		['Pichidegua',91],
	# 		['Pichilemu',96],
	# 		['Placilla',109],
	# 		['Pumanque',110],
	# 		['Quinta de Tilcoco',92],
	# 		['Rancagua',79],
	# 		['Rengo',93],
	# 		['Requínoa',94],
	# 		['San Fernando',102],
	# 		['Santa Cruz',111],
	# 		['San Vicente',95],
	# 		['Cauquenes',122],
	# 		['Chanco',123],
	# 		['Colbún',135],
	# 		['Constitución',113],
	# 		['Curepto',114],
	# 		['Curicó',125],
	# 		['Empedrado',115],
	# 		['Hualañé',126],
	# 		['Licantén',127],
	# 		['Linares',134],
	# 		['Longaví',136],
	# 		['Maule',116],
	# 		['Molina',128],
	# 		['Parral',137],
	# 		['Pelarco',117],
	# 		['Pelluhue',124],
	# 		['Pencahue',118],
	# 		['Rauco',129],
	# 		['Retiro',138],
	# 		['Río Claro',119],
	# 		['Romeral',130],
	# 		['Sagrada Familia',131],
	# 		['San Clemente',120],
	# 		['San Javier',139],
	# 		['San Rafael',121],
	# 		['Talca',112],
	# 		['Teno',132],
	# 		['Vichuquén ',133],
	# 		['Villa Alegre',140],
	# 		['Yerbas Buenas',141],
	# 		['Alto Biobío',174],
	# 		['Antuco',162],
	# 		['Arauco',155],
	# 		['Bulnes',176],
	# 		['Cabrero',163],
	# 		['Cañete',156],
	# 		['Chiguayante',144],
	# 		['Chillán',175],
	# 		['Chillán Viejo',180],
	# 		['Cobquecura',177],
	# 		['Coelemu',178],
	# 		['Coihueco',179],
	# 		['Concepción',142],
	# 		['Contulmo',157],
	# 		['Coronel',143],
	# 		['Curanilahue',158],
	# 		['El Carmen',181],
	# 		['Florida',145],
	# 		['H ualpén',153],
	# 		['Hualqui',146],
	# 		['Laja',164],
	# 		['Lebu',154],
	# 		['Los Alamos',159],
	# 		['Los Angeles',161],
	# 		['Lota ',147],
	# 		['Mulchén',165],
	# 		['Nacimiento',166],
	# 		['Negrete',167],
	# 		['Ninhue',182],
	# 		['Ñiquén',183],
	# 		['Pemuco',184],
	# 		['Penco',148],
	# 		['Pinto',185],
	# 		['Portezuelo',186],
	# 		['Quilaco',168],
	# 		['Quilleco',169],
	# 		['Quillón',187],
	# 		['Quirihue',188],
	# 		['Ránquil ',189],
	# 		['San Carlos',190],
	# 		['San Fabián',191],
	# 		['San Ignacio',192],
	# 		['San Nicolás',193],
	# 		['San Pedro de la Paz',149],
	# 		['San Rosendo',170],
	# 		['Santa Bárbara',171],
	# 		['Santa Juana',150],
	# 		['Talcahuano',151],
	# 		['Tirúa',160],
	# 		['Tomé',152],
	# 		['Treguaco ',194],
	# 		['Tucapel',172],
	# 		['Yumbel',173],
	# 		['Yungay',195],
	# 		['Angol',217],
	# 		['Carahue',197],
	# 		['Cholchol',216],
	# 		['Collipulli',218],
	# 		['Cunco',198],
	# 		['Curacautín',219],
	# 		['Curarrehue',199],
	# 		['Ercilla',220],
	# 		['Freire',200],
	# 		['Galvarino',201],
	# 		['Gorbea',202],
	# 		['Lautaro',203],
	# 		['Loncoche',204],
	# 		['Lonquimay',221],
	# 		['Los Sauces',222],
	# 		['Lumaco',223],
	# 		['Melipeuco',205],
	# 		['Nueva Imperial',206],
	# 		['Padre Las Casas',207],
	# 		['Perquenco',208],
	# 		['Pitrufquén',209],
	# 		['Pucón',210],
	# 		['Purén',224],
	# 		['Renaico',225],
	# 		['Saavedra',211],
	# 		['Temuco',196],
	# 		['Teodoro Schmidt',212],
	# 		['Toltén',213],
	# 		['Traiguén',226],
	# 		['Victoria',227],
	# 		['Vilcún',214],
	# 		['Villarrica',215],
	# 		['Ancud',238],
	# 		['Calbuco',229],
	# 		['Castro',237],
	# 		['Chaitén',254],
	# 		['Chonchi',239],
	# 		['Cochamó',230],
	# 		['Curaco de Vélez',240],
	# 		['Dalcahue',241],
	# 		['Fresia',231],
	# 		['Frutillar',232],
	# 		['Futaleufú',255],
	# 		['Hualaihué',256],
	# 		['Llanquihue',234],
	# 		['Los Muermos',233],
	# 		['Maullín',235],
	# 		['Osorno',247],
	# 		['Palena',257],
	# 		['Puerto Montt',228],
	# 		['Puerto Octay',248],
	# 		['Puerto Varas',236],
	# 		['Puqueldón',242],
	# 		['Purranque',249],
	# 		['Puyehue',250],
	# 		['Queilén',243],
	# 		['Quellón',244],
	# 		['Quemchi',245],
	# 		['Quinchao',246],
	# 		['Río Negro',251],
	# 		['San Juan de la Costa',252],
	# 		['San Pablo',253],
	# 		['Aisén',260],
	# 		['Chile Chico',266],
	# 		['Cisnes',261],
	# 		['Cochrane',263],
	# 		['Coihaique',258],
	# 		['Guaitecas ',262],
	# 		['Lago Verde',259],
	# 		['O\'Higgins',264],
	# 		['Río Ibáñez',267],
	# 		['Tortel',265],
	# 		['Antártica',273],
	# 		['Cabo de Hornos (Ex-Navarino)',272],
	# 		['Laguna Blanca ',269],
	# 		['Natales',277],
	# 		['Porvenir',274],
	# 		['Primavera',275],
	# 		['Punta Arenas',268],
	# 		['Río Verde',270],
	# 		['San Gregorio',271],
	# 		['Timaukel',276],
	# 		['Torres del Paine',278],
	# 		['Alhué',322],
	# 		['Buin',318],
	# 		['Calera de Tango',319],
	# 		['Cerrillos',280],
	# 		['Cerro Navia',281],
	# 		['Colina  ',314],
	# 		['Conchalí',282],
	# 		['Curacaví',323],
	# 		['El Bosque',283],
	# 		['El Monte',327],
	# 		['Estación Central',284],
	# 		['Huechuraba',285],
	# 		['Independencia',286],
	# 		['Isla de Maipo',328],
	# 		['La Cisterna',287],
	# 		['La Florida',288],
	# 		['La Granja',289],
	# 		['Lampa',315],
	# 		['La Pintana',290],
	# 		['La Reina',291],
	# 		['Las Condes',292],
	# 		['Lo Barnechea',293],
	# 		['Lo Espejo',294],
	# 		['Lo Prado',295],
	# 		['Macul',296],
	# 		['Maipú',297],
	# 		['María Pinto ',324],
	# 		['Melipilla',321],
	# 		['Ñuñoa',298],
	# 		['Padre Hurtado',329],
	# 		['Paine',320],
	# 		['Pedro  Aguirre Cerda',299],
	# 		['Peñaflor',330],
	# 		['Peñalolén',300],
	# 		['Pirque  ',312],
	# 		['Providencia',301],
	# 		['Pudahuel',302],
	# 		['Puente Alto',311],
	# 		['Quilicura',303],
	# 		['Quinta Normal',304],
	# 		['Recoleta',305],
	# 		['Renca',306],
	# 		['San Bernardo',317],
	# 		['San Joaquín',307],
	# 		['San José de Maipo',313],
	# 		['San Miguel',308],
	# 		['San Pedro',325],
	# 		['San Ramón',309],
	# 		['Santiago',279],
	# 		['Talagante',326],
	# 		['Tiltil',316],
	# 		['Vitacura',310],
	# 		['Corral',332],
	# 		['Futrono',340],
	# 		['Lago Ranco',341],
	# 		['Lanco',333],
	# 		['La Unión',339],
	# 		['Los Lagos',334],
	# 		['Máfil',335],
	# 		['Mariquina',336],
	# 		['Paillaco',337],
	# 		['Panguipulli',338],
	# 		['Río Bueno',342],
	# 		['Valdivia',331],
	# 		['Arica',343],
	# 		['Camarones',344],
	# 		['General Lagos',346],
	# 		['Putre',345]
	# 	]
	end

	def self.string_to_id(name)
		{ 
			"IQUIQUE" => 1,
			"ALTO HOSPICIO" => 2,
			"POZO ALMONTE" => 3,
			"CAMINA" => 4,
			"COLCHANE" => 5,
			"HUARA" => 6,
			"PICA" => 7,
			"ANTOFAGASTA" => 8,
			"MEJILLONES" => 9,
			"SIERRA GORDA" => 10,
			"TALTAL" => 11,
			"CALAMA" => 12,
			"OLLAGUE" => 13,
			"SAN PEDRO DE ATACAMA" => 14,
			"TOCOPILLA" => 15,
			"MARIA ELENA" => 16,
			"COPIAPO" => 17,
			"CALDERA" => 18,
			"TIERRA AMARILLA" => 19,
			"CHANARAL" => 20,
			"DIEGO DE ALMAGRO" => 21,
			"VALLENAR" => 22,
			"ALTO DEL CARMEN" => 23,
			"FREIRINA" => 24,
			"HUASCO" => 25,
			"LA SERENA" => 26,
			"COQUIMBO" => 27,
			"ANDACOLLO" => 28,
			"LA HIGUERA" => 29,
			"PAIGUANO" => 30,
			"PAIHUANO" => 30,
			"VICUNA" => 31,
			"ILLAPEL" => 32,
			"CANELA" => 33,
			"LOS VILOS" => 34,
			"SALAMANCA" => 35,
			"OVALLE" => 36,
			"COMBARBALA" => 37,
			"MONTE PATRIA" => 38,
			"PUNITAQUI" => 39,
			"RIO HURTADO" => 40,
			"VALPARAISO" => 41,
			"CASABLANCA" => 42,
			"CONCON" => 43,
			"CON CON" => 43,
			"JUAN FERNANDEZ" => 44,
			"PUCHUNCAVI" => 45,
			"QUILPUE" => 46,
			"QUINTERO" => 47,
			"VILLA ALEMANA" => 48,
			"VINA DEL MAR" => 49,
			"ISLA DE PASCUA" => 50,
			"LOS ANDES" => 51,
			"CALLE LARGA" => 52,
			"RINCONADA" => 53,
			"SAN ESTEBAN" => 54,
			"LA LIGUA" => 55,
			"CABILDO" => 56,
			"PAPUDO" => 57,
			"PETORCA" => 58,
			"ZAPALLAR" => 59,
			"QUILLOTA" => 60,
			"CALERA" => 61,
			"LA CALERA" => 61,
			"HIJUELAS" => 62,
			"LA CRUZ" => 63,
			"LIMACHE" => 64,
			"NOGALES" => 65,
			"OLMUE" => 66,
			"SAN ANTONIO" => 67,
			"ALGARROBO" => 68,
			"CARTAGENA" => 69,
			"EL QUISCO" => 70,
			"EL TABO" => 71,
			"SANTO DOMINGO" => 72,
			"SAN FELIPE" => 73,
			"CATEMU" => 74,
			"LLAILLAY" => 75,
			"LLAY-LLAY" => 75,
			"PANQUEHUE" => 76,
			"PUTAENDO" => 77,
			"SANTA MARIA" => 78,
			"RANCAGUA" => 79,
			"CODEGUA" => 80,
			"COINCO" => 81,
			"COLTAUCO" => 82,
			"DONIHUE" => 83,
			"GRANEROS" => 84,
			"LAS CABRAS" => 85,
			"MACHALI" => 86,
			"MALLOA" => 87,
			"MOSTAZAL" => 88,
			"SAN FCO.MOSTAZA"=>88,
			"SAN FCO DE MOSTAZAL" => 88,
			"OLIVAR" => 89,
			"PEUMO" => 90,
			"PICHIDEGUA" => 91,
			"QUINTA DE TILCOCO" => 92,
			"QUINTA TILCOCO" => 92,
			"RENGO" => 93,
			"REQUINOA" => 94,
			"SAN VICENTE" => 95,
			"SAN VICENTE T-T" => 95,
			"PICHILEMU" => 96,
			"LA ESTRELLA" => 97,
			"LITUECHE" => 98,
			"MARCHIHUE" => 99,
			"MARCHIGUE" => 99,
			"NAVIDAD" => 100,
			"PAREDONES" => 101,
			"SAN FERNANDO" => 102,
			"CHEPICA" => 103,
			"CHIMBARONGO" => 104,
			"LOLOL" => 105,
			"NANCAGUA" => 106,
			"PALMILLA" => 107,
			"PERALILLO" => 108,
			"PLACILLA" => 109,
			"PUMANQUE" => 110,
			"SANTA CRUZ" => 111,
			"TALCA" => 112,
			"CONSTITUCION" => 113,
			"CUREPTO" => 114,
			"EMPEDRADO" => 115,
			"MAULE" => 116,
			"PELARCO" => 117,
			"PENCAHUE" => 118,
			"RIO CLARO" => 119,
			"SAN CLEMENTE" => 120,
			"SAN RAFAEL" => 121,
			"CAUQUENES" => 122,
			"CHANCO" => 123,
			"PELLUHUE" => 124,
			"CURICO" => 125,
			"HUALANE" => 126,
			"LICANTEN" => 127,
			"MOLINA" => 128,
			"RAUCO" => 129,
			"ROMERAL" => 130,
			"SAGRADA FAMILIA" => 131,
			"TENO" => 132,
			"VICHUQUEN" => 133,
			"LINARES" => 134,
			"COLBUN" => 135,
			"LONGAVI" => 136,
			"PARRAL" => 137,
			"RETIRO" => 138,
			"SAN JAVIER" => 139,
			"VILLA ALEGRE" => 140,
			"YERBAS BUENAS" => 141,
			"CONCEPCION" => 142,
			"CORONEL" => 143,
			"CHIGUAYANTE" => 144,
			"FLORIDA" => 145,
			"HUALQUI" => 146,
			"LOTA" => 147,
			"PENCO" => 148,
			"SAN PEDRO DE LA PAZ" => 149,
			"SANTA JUANA" => 150,
			"TALCAHUANO" => 151,
			"TOME" => 152,
			"HUALPEN" => 153,
			"LEBU" => 154,
			"ARAUCO" => 155,
			"CANETE" => 156,
			"CONTULMO" => 157,
			"CURANILAHUE" => 158,
			"LOS ALAMOS" => 159,
			"TIRUA" => 160,
			"LOS ANGELES" => 161,
			"ANTUCO" => 162,
			"CABRERO" => 163,
			"LAJA" => 164,
			"MULCHEN" => 165,
			"NACIMIENTO" => 166,
			"NEGRETE" => 167,
			"QUILACO" => 168,
			"QUILLECO" => 169,
			"SAN ROSENDO" => 170,
			"SANTA BARBARA" => 171,
			"TUCAPEL" => 172,
			"YUMBEL" => 173,
			"ALTO BIOBIO" => 174,
			"ALTO BIO BIO" => 174,
			"CHILLAN" => 175,
			"BULNES" => 176,
			"COBQUECURA" => 177,
			"COELEMU" => 178,
			"COIHUECO" => 179,
			"CHILLAN VIEJO" => 180,
			"EL CARMEN" => 181,
			"NINHUE" => 182,
			"NIQUEN" => 183,
			"PEMUCO" => 184,
			"PINTO" => 185,
			"PORTEZUELO" => 186,
			"QUILLON" => 187,
			"QUIRIHUE" => 188,
			"RANQUIL" => 189,
			"SAN CARLOS" => 190,
			"SAN FABIAN" => 191,
			"SAN IGNACIO" => 192,
			"SAN NICOLAS" => 193,
			"TREGUACO" => 194,
			"TREHUACO" => 194,
			"YUNGAY" => 195,
			"TEMUCO" => 196,
			"CARAHUE" => 197,
			"CUNCO" => 198,
			"CURARREHUE" => 199,
			"FREIRE" => 200,
			"GALVARINO" => 201,
			"GORBEA" => 202,
			"LAUTARO" => 203,
			"LONCOCHE" => 204,
			"MELIPEUCO" => 205,
			"NUEVA IMPERIAL" => 206,
			"PADRE LAS CASAS" => 207,
			"PERQUENCO" => 208,
			"PITRUFQUEN" => 209,
			"PUCON" => 210,
			"SAAVEDRA" => 211,
			"TEODORO SCHMIDT" => 212,
			"TOLTEN" => 213,
			"VILCUN" => 214,
			"VILLARRICA" => 215,
			"CHOLCHOL" => 216,
			"ANGOL" => 217,
			"COLLIPULLI" => 218,
			"CURACAUTIN" => 219,
			"ERCILLA" => 220,
			"LONQUIMAY" => 221,
			"LOS SAUCES" => 222,
			"LUMACO" => 223,
			"PUREN" => 224,
			"RENAICO" => 225,
			"TRAIGUEN" => 226,
			"VICTORIA" => 227,
			"PUERTO MONTT" => 228,
			"CALBUCO" => 229,
			"COCHAMO" => 230,
			"FRESIA" => 231,
			"FRUTILLAR" => 232,
			"LOS MUERMOS" => 233,
			"LLANQUIHUE" => 234,
			"MAULLIN" => 235,
			"PUERTO VARAS" => 236,
			"CASTRO" => 237,
			"ANCUD" => 238,
			"CHONCHI" => 239,
			"CURACO DE VELEZ" => 240,
			"DALCAHUE" => 241,
			"PUQUELDON" => 242,
			"QUEILEN" => 243,
			"QUELLON" => 244,
			"QUEMCHI" => 245,
			"QUINCHAO" => 246,
			"OSORNO" => 247,
			"PUERTO OCTAY" => 248,
			"PURRANQUE" => 249,
			"PUYEHUE" => 250,
			"RIO NEGRO" => 251,
			"SAN JUAN DE LA COSTA" => 252,
			"SAN PABLO" => 253,
			"CHAITEN" => 254,
			"FUTALEUFU" => 255,
			"HUALAIHUE" => 256,
			"PALENA" => 257,
			"COIHAIQUE" => 258,
			"COYHAIQUE" => 258,
			"LAGO VERDE" => 259,
			"AISEN" => 260,
			"AYSEN" => 260,
			"CISNES" => 261,
			"GUAITECAS" => 262,
			"COCHRANE" => 263,
			"O'HIGGINS" => 264,
			"OHIGGINS" => 264,
			"TORTEL" => 265,
			"CHILE CHICO" => 266,
			"RIO IBANEZ" => 267,
			"PUNTA ARENAS" => 268,
			"LAGUNA BLANCA" => 269,
			"RIO VERDE" => 270,
			"SAN GREGORIO" => 271,
			"CABO DE HORNOS (EX-NAVARINO)" => 272,
			"CABO DE HORNOS" => 272,
			"ANTARTICA" => 273,
			"ANTARTIDA" => 273,
			"PORVENIR" => 274,
			"PRIMAVERA" => 275,
			"TIMAUKEL" => 276,
			"NATALES" => 277,
			"PUERTO NATALES" => 277,
			"TORRES DEL PAINE" => 278,
			"TORRES DE PAINE" => 278,
			"SANTIAGO" => 279,
			"CERRILLOS" => 280,
			"CERRO NAVIA" => 281,
			"CONCHALI" => 282,
			"EL BOSQUE" => 283,
			"ESTACION CENTRAL" => 284,
			"EST CENTRAL" => 284,
			"HUECHURABA" => 285,
			"INDEPENDENCIA" => 286,
			"LA CISTERNA" => 287,
			"LA FLORIDA" => 288,
			"LA GRANJA" => 289,
			"LA PINTANA" => 290,
			"LA REINA" => 291,
			"LAS CONDES" => 292,
			"LO BARNECHEA" => 293,
			"LO ESPEJO" => 294,
			"LO PRADO" => 295,
			"MACUL" => 296,
			"MAIPU" => 297,
			"NUNOA" => 298,
			"PEDRO AGUIRRE CERDA" => 299,
			"P AGUIRRE CERDA" => 299,
			"PENALOLEN" => 300,
			"PROVIDENCIA" => 301,
			"PUDAHUEL" => 302,
			"QUILICURA" => 303,
			"QUINTA NORMAL" => 304,
			"RECOLETA" => 305,
			"RENCA" => 306,
			"SAN JOAQUIN" => 307,
			"SAN MIGUEL" => 308,
			"SAN RAMON" => 309,
			"VITACURA" => 310,
			"PUENTE ALTO" => 311,
			"PIRQUE" => 312,
			"SAN JOSE DE MAIPO" => 313,
			"SAN JOSE MAIPO" => 313,
			"COLINA" => 314,
			"LAMPA" => 315,
			"TILTIL" => 316,
			"TIL-TIL" => 316,
			"SAN BERNARDO" => 317,
			"BUIN" => 318,
			"CALERA DE TANGO" => 319,
			"PAINE" => 320,
			"MELIPILLA" => 321,
			"SAN PEDRO DE MELIPILLA" => 321,
			"ALHUE" => 322,
			"CURACAVI" => 323,
			"MARIA PINTO" => 324,
			"SAN PEDRO" => 325,
			"TALAGANTE" => 326,
			"EL MONTE" => 327,
			"ISLA DE MAIPO" => 328,
			"PADRE HURTADO" => 329,
			"PENAFLOR" => 330,
			"VALDIVIA" => 331,
			"CORRAL" => 332,
			"LANCO" => 333,
			"LOS LAGOS" => 334,
			"MAFIL" => 335,
			"MARIQUINA" => 336,
			"PAILLACO" => 337,
			"PANGUIPULLI" => 338,
			"LA UNION" => 339,
			"FUTRONO" => 340,
			"LAGO RANCO" => 341,
			"RIO BUENO" => 342,
			"ARICA" => 343,
			"CAMARONES" => 344,
			"PUTRE" => 345,
			"GENERAL LAGOS" => 346
		}[I18n.transliterate(name).upcase]
	end
end
