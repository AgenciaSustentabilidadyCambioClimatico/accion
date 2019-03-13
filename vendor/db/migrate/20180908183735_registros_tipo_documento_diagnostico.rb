class RegistrosTipoDocumentoDiagnostico < ActiveRecord::Migration[5.1]
  def up
  	execute "INSERT INTO tipo_documento_diagnosticos (nombre,descripcion) VALUES
		        ('Diagnóstico General', 'Falta descripción'),
		        ('Planes Locales',  'Falta descripción'),
		        ('Mapa Colaborativo',  'Falta descripción'),
		        ('Registro y sistematización implementación Plan de Participación',  'Falta descripción')"
		execute "UPDATE tipo_documento_diagnosticos
						SET nombre = 'Diseño Plan Participación', descripcion = 'Falta descripción'
						WHERE nombre = 'Plan de participación'"
  end
end
