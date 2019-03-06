class Feriado < ApplicationRecord
	validates :fecha, presence: true

	def self.es?(fecha)
		es_feriado = false
		week_days = [6,0]
		fecha = Date.parse(fecha.to_s)
		if week_days.include?(fecha.wday)
			es_feriado = true
		else
			resultado = self.where(fecha: fecha).first
			es_feriado = ( resultado.blank? == false )
		end
	end

	def self.encontrar_el_dia_habil(en_n,unidad=:days,fecha=nil)
		una_semana = 7
		dias_extras_por_semana = 5
		grupo_fechas	= []
		fecha_inicial = fecha.nil? ? Date.now : Date.parse(Date.parse(fecha.to_s).strftime('%Y-%m-%d'))
		en_n = ((fecha_inicial + en_n.send(unidad.to_s())) - fecha_inicial ).to_i
		dias_agregados = ( en_n / una_semana ) * dias_extras_por_semana
		(1..en_n+dias_agregados).map do |n|
			grupo_fechas << fecha_inicial + n.day
		end
		grupo_final = []
		grupo_feriados = Feriado.where(fecha: grupo_fechas.map{|f|f.to_s}).map{|f|f.fecha}
		grupo_fechas.sort.each do |gf|
			grupo_final << { fecha: gf, es_fin_de_semana: [6,0].include?(gf.wday), es_feriado: grupo_feriados.include?(gf) }
		end 
		dias_habiles = 0
		fecha_habil = nil
		grupo_final.each do |i|
			unless i[:es_fin_de_semana] || i[:es_feriado]
				dias_habiles+=1;
				fecha_habil = i[:fecha]
			end
			break if (dias_habiles == en_n)
		end 
		fecha_habil
	end

end