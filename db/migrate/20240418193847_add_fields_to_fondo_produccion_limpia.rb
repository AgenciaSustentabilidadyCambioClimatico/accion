class AddFieldsToFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :instrumento_constitucion_estatutos_postulante, :string
    add_column :fondo_produccion_limpia, :certificado_vigencia_constitucion_postulante, :string
    add_column :fondo_produccion_limpia, :copia_instrumento_nombre_representante_postulante, :string
    add_column :fondo_produccion_limpia, :certificado_vigencia_copia_instrumento_postulante, :string
    add_column :fondo_produccion_limpia, :copia_cedula_representantes_legales_postulantes, :string
    add_column :fondo_produccion_limpia, :documento_coste_rol_unico_tributario_postulante, :string
    add_column :fondo_produccion_limpia, :antecedentes_contrato_anexo_c_postulante, :string
    add_column :fondo_produccion_limpia, :instrumento_constitucion_estatutos_receptor, :string
    add_column :fondo_produccion_limpia, :certificado_vigencia_constitucion_receptor, :string
    add_column :fondo_produccion_limpia, :copia_instrumento_nombre_representante_receptor, :string
    add_column :fondo_produccion_limpia, :certificado_vigencia_copia_instrumento_receptor, :string
    add_column :fondo_produccion_limpia, :copia_cedula_representantes_legales_receptor, :string
    add_column :fondo_produccion_limpia, :documento_coste_rol_unico_tributario_receptor, :string
    add_column :fondo_produccion_limpia, :declaracion_jurada_representante_legal_anexo_a_receptor, :string
    add_column :fondo_produccion_limpia, :declaracion_jurada_representante_legal_anexo_b_receptor, :string
    add_column :fondo_produccion_limpia, :instrumento_constitucion_estatutos_ejecutor, :string
    add_column :fondo_produccion_limpia, :certificado_vigencia_constitucion_ejecutor, :string
    add_column :fondo_produccion_limpia, :copia_instrumento_nombre_representante_ejecutor, :string
    add_column :fondo_produccion_limpia, :certificado_vigencia_copia_instrumento_ejecutor, :string
    add_column :fondo_produccion_limpia, :declaracion_jurada_representante_legal_anexo_a_ejecutor, :string
    add_column :fondo_produccion_limpia, :declaracion_jurada_representante_legal_anexo_b_ejecutor, :string
    add_column :fondo_produccion_limpia, :certificado_inicio_actividades_sii_ejecutor, :string
    add_column :fondo_produccion_limpia, :cedula_identidad_persona_ejecutor, :string
    add_column :fondo_produccion_limpia, :declaracion_jurada_simple_anexo_a_ejecutor, :string
    add_column :fondo_produccion_limpia, :declaracion_jurada_simple_anexo_b_ejecutor, :string
  end
end
