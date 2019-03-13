class CambioEstadoPpfSetMetasEstablecimiento < ActiveRecord::Migration[5.1]
  def change
  	remove_column :ppf_metas_establecimientos, :estado
  	add_column :ppf_metas_establecimientos, :estado, :integer, limit: 1, default: 0 # 0 == perndiente, 1 == en_revision
  end
end
