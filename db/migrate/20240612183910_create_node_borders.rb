class CreateNodeBorders < ActiveRecord::Migration[7.1]
  def change
    create_table :node_borders do |t|
      t.integer :node_id, null: false
      t.integer :color, default: 0
      t.integer :thickness, default: 1
      t.integer :direction, null: false
      t.jsonb :position
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
