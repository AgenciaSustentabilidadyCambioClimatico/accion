class AddMissingIndexesToCoreTables < ActiveRecord::Migration[6.0]
  def change
    # Dashboard y Tareas
    add_index :tarea_pendientes, :flujo_id
    add_index :tarea_pendientes, :tarea_id
    add_index :tarea_pendientes, :user_id
    add_index :tarea_pendientes, :estado_tarea_pendiente_id

    # Flujos
    add_index :flujos, :contribuyente_id
    add_index :flujos, :proyecto_id
    add_index :flujos, :manifestacion_de_interes_id
    add_index :flujos, :programa_proyecto_propuesta_id

    # Proyectos
    add_index :proyectos, :contribuyente_id
    add_index :proyectos, :coordinador_id

    add_index :responsables, :contribuyente_id
    add_index :establecimiento_contribuyentes, :contribuyente_id
    add_index :dato_anual_contribuyentes, :contribuyente_id
  end
end
