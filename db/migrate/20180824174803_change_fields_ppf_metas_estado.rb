class ChangeFieldsPpfMetasEstado < ActiveRecord::Migration[5.1]
  def change
  	remove_column :ppf_metas_establecimientos, :estado
  	add_column :ppf_metas_establecimientos, :estado, :boolean, default: false
  end
end
