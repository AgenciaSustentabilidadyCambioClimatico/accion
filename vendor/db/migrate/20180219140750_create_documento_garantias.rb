class CreateDocumentoGarantias < ActiveRecord::Migration[5.1]
	def change
		create_table :documento_garantias do |t|
			t.references :proyecto, foreign_key: true
			t.references :tipo_documento_garantia, foreign_key: true
			t.references :documento_garantia, foreign_key: true
			t.bigint :numero_documento
			t.date :fecha_vencimiento
			t.date :fecha_vencimiento_original
			t.bigint :monto
			t.string :archivo
			t.references :estado_documento_garantia, foreign_key: true
			t.timestamps
		end
	end
end