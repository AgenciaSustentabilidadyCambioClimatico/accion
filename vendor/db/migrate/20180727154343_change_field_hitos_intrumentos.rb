class ChangeFieldHitosIntrumentos < ActiveRecord::Migration[5.1]
  def change
  	rename_column :hito_de_prensa_instrumentos, :instrumento_id, :flujo_id
  end
end
