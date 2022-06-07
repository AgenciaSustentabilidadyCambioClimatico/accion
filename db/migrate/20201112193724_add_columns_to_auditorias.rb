class AddColumnsToAuditorias < ActiveRecord::Migration[5.1]
  def change
    add_column :auditorias, :plazo_apertura, :integer
    add_column :auditorias, :plazo_cierre, :integer
    add_column :auditorias, :con_mantencion, :boolean, default: false
  end
end
