class CreatePrivacidadPermisos < ActiveRecord::Migration[5.1]
  def change
    create_table :privacidad_permisos do |t|
      t.string :entidad
      t.text :fields_visibility
      t.timestamps
    end
  end
  
  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "privacidad_permisos" ("id", "entidad", "fields_visibility", "created_at", "updated_at") VALUES
        (1, 'usuarios', '--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nrut: Publico\nnombre_completo: Publico\ntelefono: Publico\nemail: Publico\nweb_o_red_social_1: Publico\nweb_o_red_social_2: Publico', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (2, 'instituciones', '--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nrut: Publiconrazon_social: Publico', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (3, 'establecimientos', '--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\ncasa_matriz: Publico\ndireccion: Publico\nciudad: Publico\ntelefono: Publico\nemail: Publico', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (4, 'maquinarias', '--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nnombre_maquinaria: Publico\nnumero_serie: Publico\npatente: Publico\ntipo: Publico', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (5, 'otros', '--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\nnombre: Publico\ntipo: Publico\nidentificador_unico: Publico\nimagen: Publico', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

      SELECT SETVAL('privacidad_permisos_id_seq', (SELECT MAX(id) FROM privacidad_permisos));
    SQL
  end
end
