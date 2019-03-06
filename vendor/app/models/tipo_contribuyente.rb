class TipoContribuyente < ApplicationRecord
	belongs_to :tipo_contribuyente, optional: true
	has_many :dato_anual_contribuyentes
	validates :nombre, presence: true
	#validates :descripción, presence: true

	def self.__select
		# self.id_por_nombre.map{|k,v|[k,v]}
		# DZC 2018-10-22 16:25:32 se modifica para que lea de la tabla tipo_contribuyente
		lista = []
		TipoContribuyente.all.order(id: :asc).each do |tc|
			lista << [tc.nombre, tc.id]
		end
		lista
	end

	def self.id_por_nombre
		{
			"Persona Natural" => 1,
			"Persona Natural Chilena" => 2,
			"Extranjero Con Residencia" => 3,
			"Persona Natural Extranjera Nacionalizada" => 4,
			"Extranjeros Sin Residencia" => 5,
			"Sin Per. Juridica" => 6,
			"Sociedades De Hecho" => 7,
			"Comunidades De Edificios" => 8,
			"Sucesiones O Comunidades Hered" => 9,
			"Otras Organizaciones Sin P. Juridica" => 10,
			"Comunidad Disolucion Soc. Conyugal" => 11,
			"Persona Juridica Comercial" => 12,
			"Sociedades Anonimas Cerradas" => 13,
			"Soc. Responsabilidad Limitada" => 14,
			"Empr. Individual Resp. Ltda." => 15,
			"Socieda Colectiva Civil" => 16,
			"Sociedad Por Acciones" => 17,
			"Sociedades Anonimas Abiertas" => 18,
			"Encomanditas Por Acciones" => 19,
			"Fondo De Inversion Privado" => 20,
			"Soc. Plataforma Art 41 D" => 21,
			"Sociedad Colectiva Comercial" => 22,
			"Soc Legal Minera" => 23,
			"Fondo De Inversion Publico" => 24,
			"Soc. Anonima Deportiva" => 25,
			"Encomandita Simple" => 26,
			"Sociedad Anonima Con Garantia Reciproca" => 27,
			"Companias De Seguro" => 28,
			"Administradora Fondos De Pensiones" => 29,
			"Bancos" => 30,
			"Org. Sin Fines De Lucro" => 31,
			"Otra Osfl" => 32,
			"Junta De Vecinos, Org. Comunitaria" => 33,
			"Fundacion" => 34,
			"Cooperativa" => 35,
			"Club Deportivo" => 36,
			"Asoc. Gremial" => 37,
			"Corporacion" => 38,
			"Sindicato" => 39,
			"Entidad Individual Educacional Ley 20845" => 40,
			"Corporacion Educacional Ley 20845" => 41,
			"Sociedades Extranjeras" => 42,
			"Entidad Sin Residencia" => 43,
			"Agencia" => 44,
			"Sociedad Extranjera Res 5412/2000" => 45,
			"Instituciones Fiscales" => 46,
			"Org. Administracion Publica" => 47,
			"Ministerios" => 48,
			"Org. Ministerio Salud" => 49,
			"Org. Educacion Superior" => 50,
			"Org. Ministerio Justicia" => 51,
			"Organismo Autonomo Del Estado" => 52,
			"Org. Ministerio Defensa" => 53,
			"Municipalidades" => 54,
			"Municipalidad" => 55,
			"Liceo O Colegio Municipal" => 56,
			"Otro Org. Municipal" => 57,
			"Organismos Internacionales" => 58,
			"Organismos Internacional" => 59,
			"Embajadas" => 60,
			"No Clasificados" => 61,
			"No Clasificado" => 62
		}
	end
end
