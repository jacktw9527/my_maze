class CreateNodes < ActiveRecord::Migration[7.1]
  def change
    create_table :nodes do |t|
      t.integer :maze_id, null: false
      t.integer :color, default: 0
      t.jsonb :coordinate
      t.jsonb :position
      t.bigint :parent_node_id, index: true
      t.integer :width
      t.integer :height

      t.timestamps
    end

    add_foreign_key :nodes, :nodes, column: :parent_node_id
  end
end
