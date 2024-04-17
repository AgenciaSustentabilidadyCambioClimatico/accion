class AddRevisionToCuestionarioFpl < ActiveRecord::Migration[5.1]
  def change
    add_column :cuestionario_fpls, :revision, :integer
  end
end
