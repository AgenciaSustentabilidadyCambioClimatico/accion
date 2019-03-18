class ChangeNullCargoOnPersonaCargos < ActiveRecord::Migration[5.1]
  def change
    change_column_null :persona_cargos, :cargo_id, true
  end
end
