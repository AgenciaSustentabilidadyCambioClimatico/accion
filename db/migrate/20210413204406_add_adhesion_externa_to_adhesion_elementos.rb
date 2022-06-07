class AddAdhesionExternaToAdhesionElementos < ActiveRecord::Migration[5.1]
  def change
    add_reference :adhesion_elementos, :adhesion_externa, foreign_key: { to_table: :adhesiones }
  end
end
