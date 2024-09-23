module TareaPendientesHelper
   	def nombre_tarea_fpl(flujo_id)
		# Encuentra el objeto FondoProduccionLimpia por flujo_id
		fondo_produccion_limpia = FondoProduccionLimpia.find_by(flujo_id: flujo_id)
		
		if fondo_produccion_limpia.present?		
			# Si fondo_produccion_limpia es nil, devuelve un mensaje predeterminado
			return "Información no disponible" unless fondo_produccion_limpia
		
			# Obtiene el código de proyecto de fondo_produccion_limpia
			nombre_fpl = fondo_produccion_limpia.codigo_proyecto || 'Código no disponible'
			
			# Encuentra el flujo asociado utilizando el flujo_apl_id
			flujo = Flujo.find_by(id: fondo_produccion_limpia.flujo_apl_id)
			
			# Si flujo es nil, devuelve un mensaje predeterminado
			return "Información no disponible" unless flujo
		
			# Obtiene el nombre del acuerdo asociado a manifestacion_de_interes
			manifestacion_de_interes = ManifestacionDeInteres.find_by(id: flujo.manifestacion_de_interes_id)
			nombre_acuerdo = manifestacion_de_interes&.nombre_acuerdo || 'Acuerdo no disponible'

			# Encuentra el flujo asociado utilizando el flujo_id del fpl
			flujo_fpl = Flujo.find_by(id: fondo_produccion_limpia.flujo_id)
			
			# Determina el código_fpl basado en tipo_instrumento_id
			tipo_instrumento_id = flujo_fpl.tipo_instrumento_id || -1
		
			codigo_fpl = case tipo_instrumento_id
						when TipoInstrumento::FPL_LINEA_1_1, TipoInstrumento::FPL_LINEA_5_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
						"DyAPL"
						when TipoInstrumento::FPL_LINEA_1_2_1, TipoInstrumento::FPL_LINEA_1_2_2, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
						"SyC"
						when TipoInstrumento::FPL_LINEA_1_3, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
						"EdC"	
						else
						"Desconocido" # Valor por defecto en caso de que no coincida
						end
			
			# Construye y retorna la cadena resultante
			"#{nombre_fpl} - #{codigo_fpl} - #{nombre_acuerdo}"
		end
	end
end