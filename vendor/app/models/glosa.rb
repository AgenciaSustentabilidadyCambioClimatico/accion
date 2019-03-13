class Glosa < ApplicationRecord
	has_many :proyecto_actividad
	
	RRHH_PROPIO = 1
	RRHH_EXTERNO = 2
	GASTOS_OPERACIONALES = 3
	GASTOS_ADMINISTRATIVOS = 4

	def self.todas_las_glosas
		[	
			{id: RRHH_PROPIO, nombre: "RRHH propio"},
			{id: RRHH_EXTERNO, nombre: "RRHH externo"},
			{id: GASTOS_OPERACIONALES, nombre: "Gastos operacionales"},
			{id: GASTOS_ADMINISTRATIVOS, nombre: "Gastos administrativos"},
		]
	end

	def self.glosa_por_id(id)
		case id
		when RRHH_PROPIO
			"RRHH propio"
		when RRHH_EXTERNO
			"RRHH externo"
		when GASTOS_OPERACIONALES
			"Gastos operacionales"
		when GASTOS_ADMINISTRATIVOS
			"Gastos administrativos"			
		end
	end
end