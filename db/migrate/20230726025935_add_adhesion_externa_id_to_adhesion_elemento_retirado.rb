class AddAdhesionExternaIdToAdhesionElementoRetirado < ActiveRecord::Migration[5.1]
  def change
    add_column :adhesion_elemento_retirados, :adhesion_externa_id, :integer
  end
end
