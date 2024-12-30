class ExcelParser 
	attr_accessor :errors, :tabulated, :sheet, :sheet_name, :columns
	def initialize(file, columns={}, sheet=nil, start_index=1, first_row=2, last_row=nil)
		spreadsheet 		= Roo::Spreadsheet.open(file)
		self.errors 		= []
		self.tabulated 	= []
		self.sheet_name = ( sheet.nil? ? spreadsheet.sheets().first : sheet )
		if spreadsheet.sheets().include?(self.sheet_name)
			self.sheet 		=	spreadsheet.sheet(self.sheet_name)
			self.columns 	= __columns(columns,start_index)
			tabulated_data(first_row,last_row)
		else
			self.errors << "No existe la hoja #{@sheet_name} en el archivo excel"
		end
	end

	def self.parameterize(s)
		unless s.nil?||s.empty?
			t={'á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u','%'=>'_porcentaje_','-'=>''};
			s=s
				.downcase
				.gsub(/\<\/?[a-z]+\>|\.|,/,'')
				.gsub(/[\s\/\)\(]/,'_')
				.split("").map{|c|t.has_key?(c)?t[c]:c}
				.compact
				.join("")
				.gsub(/(^_|_$)/,'')
				.gsub(/__/,'_')
				.sub(/nº|n°/,'numero')
				.gsub('$','') #Para eliminar los signos pesos
				.to_sym
		end
		s
	end

	private 
		def __columns(columns={},start_index=1)
			if !self.sheet.first_row.nil?
				cols = self.sheet.row(start_index).map do |name|
					next if name.nil?
					c_alias = ExcelParser.parameterize(name.to_s)
					if columns.size > 0
						if columns.is_a?(Hash) && columns.has_key?(c_alias)
							c_alias = columns[c_alias]
						elsif columns.is_a?(Array) && columns.include?(c_alias)
							c_alias = c_alias #en realidad mantiene el valor recorrido
						else
							c_alias = nil
						end
					end
					c_alias
				end
			else
				cols = []
			end
			#Verificamos que no sea un array de nils
			if cols.compact.size == 0
				self.errors  << "No se encontraron títulos en la primera fila de la hoja #{self.sheet_name} del archivo excel"
			end
			cols
		end

		def tabulated_data(first_row=2,last_row=nil)

			if self.errors.size == 0
				last_row = last_row.nil? ? self.sheet.last_row : last_row
				(first_row..last_row).each do |number|
					row = {}
					self.sheet.row(number).each_with_index.each do |cell, index|
						key = self.columns[index]
						unless key.nil?
							row[key.to_sym] = ( (cell.is_a?(String))  ? cell.strip : cell )
						end
					end
					#no guardamos la fila si todos los campos son nulos
					self.tabulated << row unless (row.map{|i,r| r unless r.nil? }.compact.size == 0)
				end
			end
		end
end
