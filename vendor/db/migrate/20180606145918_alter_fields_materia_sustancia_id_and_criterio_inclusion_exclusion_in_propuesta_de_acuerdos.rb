class AlterFieldsMateriaSustanciaIdAndCriterioInclusionExclusionInPropuestaDeAcuerdos < ActiveRecord::Migration[5.1]
  def up
  	remove_foreign_key :propuesta_de_acuerdos, :unidad_bases
  	change_column :propuesta_de_acuerdos, :unidad_base_id, 'character varying USING CAST(criterio_inclusion_exclusion AS character varying)', null: true
  	change_column :propuesta_de_acuerdos, :materia_sustancia_id, :integer, null: true
  	change_column :propuesta_de_acuerdos, :criterio_inclusion_exclusion, 'text USING CAST(criterio_inclusion_exclusion AS text)'
  	rename_column :propuesta_de_acuerdos, :unidad_base_id, :tipo_cuantitativa
  end

  def down
  	# => No es necesario volver a dejar NOT NULL el campo materia_sustancia_id
  	rename_column :propuesta_de_acuerdos, :tipo_cuantitativa, :unidad_base_id
  	change_column :propuesta_de_acuerdos, :unidad_base_id, 'integer USING CAST(criterio_inclusion_exclusion AS integer)', null: true
  	change_column :propuesta_de_acuerdos, :criterio_inclusion_exclusion, 'integer USING CAST(criterio_inclusion_exclusion AS integer)'
  	execute <<-SQL
  		UPDATE propuesta_de_acuerdos SET unidad_base_id = NULL;
  	SQL
  	add_foreign_key :propuesta_de_acuerdos, :unidad_bases
  end
end