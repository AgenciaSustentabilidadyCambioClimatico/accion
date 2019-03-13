module PostgresHelper
  #fuente: http://stackoverflow.com/a/3194776/183791
  #Usado para cambiar temporalmente el schema search path dentro del bloque
  def self.with_schema(schema_name, &block)
    conn = ActiveRecord::Base.connection
    old_schema_search_path = conn.schema_search_path
    conn.schema_search_path = schema_name
    begin
      yield
    ensure
      conn.schema_search_path = old_schema_search_path
    end
  end
end