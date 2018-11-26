class ModificaProvincias < ActiveRecord::Migration[5.1]
  def up
  	# DZC 2018-11-07 17:58:18 permitimos que region_id pueda ser nulo
  	change_column_null :provincias, :region_id, true

  	# DZC 2018-11-07 17:14:43 eliminamos todos los registros de la tabla provincias
  	execute <<-SQL
  		DELETE FROM provincias;
		SQL

		# DZC 2018-11-07 17:28:58 agregamos todas las provincias desde la tabla comunas_alternativas
		execute <<-SQL
  		INSERT INTO provincias (nombre)
  			SELECT DISTINCT provincia FROM comunas_alternativas;
		SQL
  end

  def down

  end
end
